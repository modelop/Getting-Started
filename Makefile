.PHONY: deploy stop

deploy: stop
	docker swarm init
	docker stack deploy -c docker-compose.yaml --resolve-image changed fs-vanilla
	bash -x setup.sh
	bash -x load.sh

modeldeploy: stop
	docker swarm init
	docker stack deploy -c docker-compose-deploy.yaml --resolve-image changed fs-vanilla
	bash -x setup.sh
	bash -x load.sh

deploysecrets: stop
	docker swarm init
	cd credentials && ./loadSecrets.sh
	docker stack deploy -c docker-compose-secrets.yaml --resolve-image changed fs-vanilla
	bash -x setup.sh
	bash -x load.sh

stop:
	docker stack rm fs-vanilla && ([ $$? -eq 0 ] && echo "success!") || echo "failure!"
	docker swarm leave --force && ([ $$? -eq 0 ] && echo "success!") || echo "failure!"

clean-db:
	docker volume rm fs-vanilla_db-data && ([ $$? -eq 0 ] && echo "success!") || echo "failure!"
