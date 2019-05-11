
# Introduction 
This section of the repo contains files that help with installing a stateful Fastscore fleet inside a pre-existing Kubernetes cluster

## Prerequisites
In order to use this repo, it is assumed that you have already:
* Installed and configured a Kubernetes cluster
* Installed and configured `kubectl` command-line tool to talk to the appropriate kubernetes cluster
* Installed the `htpasswd` utility on whatever host/container you're using to run the Makefile
  * Typically this is found in the `httpd-tools` package of your favorite package manager
    * It's only used to add/modify the usernames/passwords to access the Fastscore environment

## Quick Start
* Decide if you would like to use persistent or stateless operation for your installation
  * Persistent operation includes the use of `persistentVolumeClaim` objects, which require underlying `storageClass` objects to be provided. If you don't know what this means, we suggest using stateless (which is the default method)
	* If using persistent operation, either edit the `Makefile` parameter `$deployment_type` to equal `persistent`, or invoke each `make` command using the appropriate variable override:
    *e.g.: `make deploy deployment_type=persistent`
* `make parameters`
  * This will create a `env-parameters.txt` file containing every unique `${PARAMETER}` present in files under `templates/`
* Edit the created parameter file to include requisite information
  * e.g. GIT credentials, hostname, IP address associated with the environment, etc.
  * Parameters should be self-explanatory
  * If you want to add users/modify passwords for CLI access, you can fill in the `${ENV_CLI_USERNAMES_COMMA_SEPARATED}` line in `env-parameters.txt` with a comma-separated list of users (or edit `templates/config/cli_usernames` yourself)
    * If you don't want/need to update/modify the CLI passwords, just delete the line before running `make environment` and the system will continue using the default user/password for CLI access
* **OPTIONAL** - If you want to update CLI username/passwords: `make cli-passwords`
  * This will prompt you to enter a password for each username you entered in the previous step
  * This creates a hashed and salted password file, which is used to create a kubernetes configMap which is used by the Access service
* `make deploy`
  * This will take the values you filled in during the previous step, and create new copies of the templated files under the `implementation/` directory, then create the required kubernetes resources based on these new files

At this point, your kubernetes system will likely be auto-creating a Loadbalancer for a few minutes. You can find the URL you'll need to hit by typing:
* `kubectl get svc/access`

Once that DNS has been created, you can connect with your fastscore CLI like this:

* `fastscore connect https://<Loadbalancer_DNS_or_IP>/dashboard`
* `fastscore login basicauth`
  * Then follow the prompts for username/password
    * You should have just created these values in the Quick Start

### URLs
* dashboard will be accessible at: `https://<Loadbalancer_DNS_or_IP>/dashboard`
* viz will be accessible at: `https://<Loadbalancer_DNS_or_IP>/viz`
* scheduler will be accessible at: `https://<Loadbalancer_DNS_or_IP>/scheduler`

## Project structure

### Top-level directories
* `Makefile` - contains targets that help with creation of your Fastscore environment. Should be self-describing
* `templates/` - initially contains all files that make up the project
  * Files in subdirectories of `templates/` can contain parameters - in `${PARAM}` form -  which will be replaced when `make enviroment` is invoked
* `implementation/` - initially empty; this is where completed files from the `templates/` directory end up
  * After `implementation/` has been populated with completed files, we can use `make deploy` to create all required resources
* `scripts/` - contains helper scripts for manipulating the environment
  * `restart_access.sh` will delete/recreate the configMap objects and kill the access pod (thereby restarting it)
    * This is helpful if it's necessary to iterate on Access configuration
  * `replace_parameters.sh` is used by the `Makefile` to find and replace parameters during environment setup

### Subdirectories
Initially in `templates/`, but copied into `implementation/`, the structure of subdirectories are as follows:
* `config/` - contains config files that are intended to be build into configMap kubernetes objects (done in Makefile)
  * `airflow_config/` contains files used to create Airflow scheduling DAGs, and scripts associated with those DAGs
* `manifests/release/` - contains manifest files (in .yaml format) which define necessary kubernetes objects:
  * namespaces
  * deployments
  * services
  * persistentVolumeClaims (if using the persistent deployment type)
  * secrets
  * `fastscore-core.yaml` defines deployments and services for the main supporting Fastscore services
  * `fastscore-engines.yaml` defines three deployments/services for `fastscore/engine` containers (used to run models)
    * Feel free to modify these to fit your requirements
  * `fastscore-disk.yaml` contains a definition of two persistentVolumeClaims which are used to persist metadata in viz and scheduler
  * `fastscore-aux.yaml` contains a couple of helper services that are occasionally used in demonstration/PoC environments
    * A MySQL-based database which can be used to back model-manage if Git is unavailable
    * A single-host Kafka service
* `manifests/beta/` contains manifest files associated with beta functionality; enabled by setting `$beta=true` in the `Makefile`

## On Templates and Manifests
YAML files that will eventually define the environment start out inside the `templates/` directory. The `scripts/` directory contains a helper script that, when invoked using `make environment`:
1) Copies those files into the `implementation/` directory
2) Finds any values parameterized with a variable starting with ENV (e.g. `${ENV_GIT_USERNAME}`)
3) Replaces those parameters with values associated with them in the `env-parameters.txt` file created by invoking `make parameters`

### More details
The Makefile in the base directory contains two targets: `parameters` and `environment`.

`make parameters` searches through the `template/` directory for all variables, and loads them into associated parameter files. For example, take a `secrets.yaml` file:

```
apiVersion: v1
kind: Secret
metadata:
  name: credentials
type: Opaque
stringData:
  git-username: ${ENV_GIT_USERNAME}
  git-password: ${ENV_GIT_PASSWORD}
```

After you run `make parameters`, an `env-parameters.txt` file will appear in the base directory that looks like this:

```
${ENV_GIT_USERNAME}=
${ENV_GIT_PASSWORD}=
```

You would then edit that file to contain the correct information:

```
${GIT_USERNAME}=secret_git_username
${GIT_PASSWORD}=secret_git_password
```

Then when you execute `make environment` (which is automatically invoked by `make deploy`) the invoked script will read that `env-parameters.txt` file and replace the values on the left of the `=` with the values on the right, and write new files with the same names as those in the `templates/` directory into the `implementation/` directory. At that point, files in `implementation/` will be completed, and you only need to `make deploy` and/or use `kubectl` to do what you like with them.

**NOTE**: `make environment` takes a paremeter file as an argument. It may be helpful to create a `default-parameters.txt` file to save environment-specific (non-credential) information and commit that to a branch associated with a particular environment. e.g:
```
# default-parameters.txt
# Lines (comments) beginning with # will be ignored, and are safe inside a parameters file
# Lines should not be left blank, however, as that will disrupt the find/replace logic
${ENV_GIT_BRANCH}=test
${ENV_GIT_PASSWORD}=<TODO>
${ENV_GIT_URL}=https://github.com/your-organization/fastscore
${ENV_GIT_USERNAME}=<TODO>
```

## Scheduler/Airflow DAGs
`fastscore/scheduler` is a single-container scheduling solution based on Apache Airflow. Airflow operates based on DAGs (Directed Acyclic Graphs), defined in Python code. These DAGs define one or more steps, along withthe relationship between those steps, to create a workflow that's accomplished every time the DAG is invoked, as well as a schedule for the DAG, if required.

In this deployment, these DAGs and associated scripts are delivered into the Scheduler container by use of Kubernetes `configMap` objects.

In order to create new DAG, or modify an existing one, simply modify the files found in `config/airflow_config/dags/` and `config/airflow_config/processing/`. The `dags/` directory contains Python scripts defining the DAGs themselves, and the `processing/` directory contains any scripts that will be invoked by the DAGs. See the existing files in those directories for examples.

After that, simply `make dags` to push the new DAGs into your deployment.
