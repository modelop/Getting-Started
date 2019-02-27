#      _____         _     ____
#     |  ___|_ _ ___| |_  / ___|  ___ ___  _ __ ___
#     | |_ / _` / __| __| \___ \ / __/ _ \| '__/ _ \
#     |  _| (_| \__ \ |_   ___) | (_| (_) | | |  __/
#     |_|  \__,_|___/\__| |____/ \___\___/|_|  \___|
#
#  **NOTE**: In order to run commands in this Makefile, the following possibly non-standard utilities must be installed on the system 
#  	* `kubectl` - kubernetes command-line interface (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
#  	* `htpasswd` - Apache secure password file generator (typically found in apache2-utils package)
#
#  **NOTE**: secrets.yaml must be modified before running make secrets
#  	* `kubectl get secrets` to see what secrets exist in your environment
#
#  **NOTE**: If fastscore CLI passwords must be created, config/cli_usernames must be populated with a list of users who need individual access
#  	* First, make sure the config/cli_usernames file contains a list (one per line) of usernames for which passwords should be generated
#  	* Second, run `make cli-passwords`
#  	** This will prompt you to enter a password for each user to stdin, and create the .htpasswd file containing usernames and hashed and salted passwords


######################
#  Stack Deployment  #
######################

.PHONY: deploy config clean configmap cleanupconfigmap secrets cleanupsecrets parameters
=======

deploy: secrets configmap stack

stack:
	kubectl apply -f manifests/

clean: cleanupconfigmap cleanupsecrets
	kubectl delete all -l stack=fastscore

configmap: cleanupconfigmap
	kubectl create configmap cli-passwd --from-file=config/cli_passwd || echo "done"
	kubectl create configmap airflow-dags-configmap --from-file=config/airflow_config/dags || echo "done"
	kubectl create configmap airflow-processing-configmap --from-file=config/airflow_config/processing || echo "done"

cleanupconfigmap:
	kubectl delete configmap cli-passwd || echo "done"
	kubectl delete configmap airflow-dags-configmap || echo "done"
	kubectl delete configmap airflow-processing-configmap || echo "done"

secrets: 
	kubectl create -f config/secrets.yaml || echo "done"

cli-passwords:
	touch config/cli_passwd && while read f; do echo "Enter password for user $$f"; htpasswd config/cli_passwd $$f ; done < config/cli_usernames

cleanupsecrets:
	kubectl delete secrets --all

environment:
	bash -c "scripts/replace_parameters.sh translate ./parameters.txt ./templates/ ./manifests/"
	
parameters:
	scripts/replace_parameters.sh discover ./templates/ >> parameters.txt