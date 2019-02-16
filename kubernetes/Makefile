#      _____         _     ____
#     |  ___|_ _ ___| |_  / ___|  ___ ___  _ __ ___
#     | |_ / _` / __| __| \___ \ / __/ _ \| '__/ _ \
#     |  _| (_| \__ \ |_   ___) | (_| (_) | | |  __/
#     |_|  \__,_|___/\__| |____/ \___\___/|_|  \___|
#
#  **NOTE**: In order to run commands in this Makefile, the following possibly non-standard utilities must be installed on the system (in fact, the simplest way is to run this from inside a fastscore/init container!):
#  	* `kubectl` - kubernetes command-line interface (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
#  	* `fastscore` - fastscore command-line interface (try `pip install fastscore-cli`)
#  	* `htpasswd` - Apache secure password file generator (typically found in apache2-utils package)
#
#  **NOTE**: If secrets need to be created, secrets.yml must be modified before running make secrets
#  	* `kc get secrets` to see if secrets exist in your environment
#
#  **NOTE**: If fastscore CLI passwords must be created, config/cli_usernames must be populated with a list of users who need individual access
#  	* First, make sure the config/cli_usernames file contains a list (one per line) of usernames for which passwords should be generated
#  	* Second, run `make cli-passwords`
#  	** This will prompt you to enter a password for each user to stdin, and create the .htpasswd file containing usernames and hashed and salted passwords
#  **NOTE**: for SSO to work properly (and thereby, access to the platform), the deployment must have a valid DNS hostname associated to it
#  This DNS name *must* be set in the following two places (and they must agree):
#  	* manifests/fastscore.yaml in the FASTSCORE_HOSTNAME variable in the section controlling the access container
#  	* config/vouch_config/config.yaml under the 'domain' section


######################
#  Stack Deployment  #
######################

.PHONY: deploy config clean configmap cleanupconfigmap secrets cleanupsecrets 

deploy: secrets configmap stack

stack:
	kubectl apply -f manifests/

clean: cleanupconfigmap cleanupsecrets
	kubectl delete all -l stack=fastscore

configmap: cleanupconfigmap
	date +%s | shasum | base64 | head -c 16 > config/vouch_config/secret
	kubectl create configmap cli-passwd --from-file=config/cli_passwd || echo "done"
#	kubectl create configmap nginx-configmap --from-file=config/nginx_config/ || echo "done"
	kubectl create configmap vouch-configmap --from-file=config/vouch_config/ || echo "done"
	kubectl create configmap airflow-dags-configmap --from-file=config/airflow_config/dags || echo "done"
	kubectl create configmap airflow-processing-configmap --from-file=config/airflow_config/processing || echo "done"

cleanupconfigmap:
	kubectl delete configmap cli-passwd || echo "done"
#	kubectl delete configmap nginx-configmap || echo "done"
	kubectl delete configmap vouch-configmap || echo "done"
	kubectl delete configmap airflow-dags-configmap || echo "done"
	kubectl delete configmap airflow-processing-configmap || echo "done"

secrets: 
	kubectl create -f config/secrets.yml || echo "done"

cli-passwords:
	touch config/cli_passwd && while read f; do echo "Enter password for user $$f"; htpasswd config/cli_passwd $$f ; done < config/cli_usernames

cleanupsecrets:
	kubectl delete secrets --all
