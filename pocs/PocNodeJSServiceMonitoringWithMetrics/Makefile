test-local:
	@clear && mv .env .. && make build && make publish && cp ../.env . && make run

docker-prepare:
	@echo -e "Running npm install"
	@npm install

build:
	@echo -e "Building docker image"
	@docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
	@docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t registry.gitlab.com/guidesmiths/chapters/devops/research/sample-nodejs-service-with-metrics . --push

run:
	@echo -e "Running docker image (Control+C to stop it)"
	@docker run --env-file .env --rm registry.gitlab.com/guidesmiths/chapters/devops/research/sample-nodejs-service-with-metrics

clean:
	@rm -fR node_modules/
