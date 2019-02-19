
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
* config/ - contains config files that are intended to be build into configMap kubernetes objects (done in Makefile)
 * airflow_config/ contains an example DAG and processing script
* manifests/ - contains k8s manifest files describing deployments and services (both k8s objects) that make up the Fastscore fleet
 * fastscore-core.yaml defines deployments and services for the main supporting Fastscore services
 * fastscore-engines.yaml defines three deployments/services for `fastscore/engine` containers (used to run models)
  * Feel free to modify these to fit your requirements
 * fastscore-disk.yaml contains a definition of two persistentVolumeClaims which are used to persist metadata in viz and scheduler
 * fastscore-aux.yaml contains a couple of helper services that are occasionally used in demonstration/PoC environments
  * A MySQL-based database which can be used to back model-manage if Git is unavailable
  * A single-host Kafka service

## Quick Start
* Run `grep -R {{.*}} .` to find each instance of a placeholder variable you need to replace with your own information
 * These currently include:
  * The Git repo URL and branch for the Git repo you want to use to back your model assets (in `fastscore-core.yaml`)
  * The username and password to create the kubernetes secret we'll use to give model-manage access to the Git repo (in `secrets.yaml`)
  * The name of the underlying kubernetes storageClass against which you want to provision your persistentVolumeClaims (in `fastscore-disk.yaml`)
* Edit `config/cli_usernames` to include usernames you'd wish to allow access to the Fastscore fleet
 * This is not necessary, as there is a default user/password already (admin/password), but it is recommended for anything beyond a simple "Hello, world!" style deployment
 * Run `make cli-passwords` To create secrets for CLI access; you will be prompted to enter a password for each user specified in `config/cli_usernames`
* Run `make deploy`
 * This will create a secret from `config/secrets.yaml` and a configMap from `config/airflow_config/`, then create resources defined in the `.yaml` files contained in `manifests/`
