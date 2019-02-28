
# Introduction 
This section of the repo contains files that help with installing a basic Fastscore fleet inside a pre-existing Kubernetes cluster

## Prerequisites
In order to use this repo, it is assumed that you have already:
* Installed and configured a Kubernetes cluster
* Installed and configured `kubectl` command-line tool to talk to the appropriate kubernetes cluster
* Installed the `htpasswd` utility on whatever host/container you're using to run the Makefile
 * Typically this is found in the `httpd-tools` package of your favorite package manager
 * It's only used to add/modify the usernames/passwords to access the Fastscore environment

## Project structure
* Makefile - contains helper code to assist with initial configuration/installation into a kubernetes cluster (should be fairly self-describing)
* templates/ - contains source files for manifests and some configs
 * templates/config/ contains any configs that need to be parameterized (parameters are searched through when running `make parameters`)
 * templates/manifests/ - contains source files for manifests that need to be parameterized (again, parameters are searched with `make parameters`)
* config/ - after running `make environment`, contains all config files that are intended to be build into configMap kubernetes objects (done in Makefile)
 * airflow_config/ contains an example DAG and processing script
* manifests/ - after running `make environment`, contains all k8s manifest files describing deployments and services (both k8s objects) that make up the Fastscore fleet
 * fastscore-core.yaml defines deployments and services for the main supporting Fastscore services
 * fastscore-engines.yaml defines three deployments/services for `fastscore/engine` containers (used to run models)
  * Feel free to modify these to fit your requirements
 * fastscore-disk.yaml contains a definition of two persistentVolumeClaims which are used to persist metadata in viz and scheduler
 * fastscore-aux.yaml contains a couple of helper services that are occasionally used in demonstration/PoC environments
  * A MySQL-based database which can be used to back model-manage if Git is unavailable
  * A single-host Kafka service

## Quick Start
* Run `make parameters`
* Edit the `env-parameters.txt` and `config-parameters.txt` files that were produced by `make parameters` to include appropriate values for your environment
 * Examples of parameters to edit include:
  * The Git repo URL and branch, as well as username/password for the Git repo you want to use to back your model assets
  * The name of the underlying kubernetes storageClass against which you want to provision your persistentVolumeClaims
* Run `make environment`
* Edit `config/cli_usernames` to include usernames you'd wish to allow access to the Fastscore fleet
* Run `make cli-passwords` To create secrets for CLI access; you will be prompted to enter a password for each user specified in `config/cli_usernames`
* Run `make deploy`

At this point, your kubernetes system will likely be auto-creating a Loadbalancer for a few minutes. You can find the URL you'll need to hit by typing:
* `kubectl get svc/access`

Once that DNS has been created, you can connect with your fastscore CLI like this:

* `fastscore connect https://<Loadbalancer_DNS_or_IP>/dashboard
* `fastscore login basicauth`
 * Then follow the prompts for username/password
  * You should have just created these values in the Quick Start

### URLs
* dashboard will be accessible at: https://<Loadbalancer_DNS_or_IP>/dashboard
* viz will be accessible at: https://<Loadbalancer_DNS_or_IP>/viz
* scheduler will be accessible at: https://<Loadbalancer_DNS_or_IP>/scheduler
 * Technically, this will redirect to https://<Loadbalancer_DNS_or_IP>/scheduler/admin/

## On Templates and Manifests

The `templates/` directory contains two subfolders: `config/` and `manifests/`. These directories contain files that will be searched through for parameters (written in environment-variable notation: `${EXAMPLE_PARAMETER}`.

When `make parameters` is run, those directories are searched for appropriate variables, then parameters files are created from those variables.

For example: files used to create secrets would contain a prompt in environment-variable format:
```
apiVersion: v1
kind: Secret
metadata:
  name: credentials
type: Opaque
stringData:
  git-username: ${GIT_USERNAME}
  git-password: ${GIT_PASSWORD}
```

After `make parameters` was run, `env-parameters.txt` would contain these lines:

```
GIT_USERNAME=
GIT_PASSWORD=
```

You would then edit that file to contain the correct information:
```
GIT_USERNAME=secret_git_username
GIT_PASSWORD=secret_git_password
```
Then when you execute `make environment` the invoked script will read that `env-parameters.txt` file and replace the values on the left of the `=` with the values on the right, and write new files with the same names as those in the `templates/manifests/` directory into the `manifests/` directory. At that point, files in `manifests/` will be completed, and you only need to `make deploy` and/or use `kubectl` to do what you like with them.

This process currently is done for both the `manifests/` and `config/` directories.
