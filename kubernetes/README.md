
# Introduction 
This section of the repo contains two subdirectories that help with installing a basic Fastscore fleet inside a pre-existing Kubernetes cluster

## Prerequisites
In order to use this repo, it is assumed that you have already:
* Installed and configured a Kubernetes cluster
* Installed and configured `kubectl` command-line tool to talk to the appropriate kubernetes cluster
* Installed the `htpasswd` utility on whatever host/container you're using to run the Makefile
  * Typically this is found in the `httpd-tools` package of your favorite package manager
    * It's only used to add/modify the usernames/passwords to access the Fastscore environment

## Sections
* The `stateless/` directory contains a set of files and directories that will install a fully stateless Fastscore cluster
  * This means no use of any `persistentVolumeClaim` or `storageClass` objects
  * This also means any restart of the system will result in losing metadata associated with things like visualizations, or a non-git-backed model-manage
* The `persistent/` directory contains a set of files and directores that will install a Fastscore cluster with the use of a `persistentVolumeClaim` for any service that could benefit from persistent state
  * This should be used if your kubernetes installation has access to one or more `storageClass` objects that you are comfortable using. If not, please use the stateless install directories
