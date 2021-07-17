## Equal Experts Assignment

.PHONY: all

EXECUTABLES = docker kubectl
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),,$(error "No $(exec) in PATH. Please refer to the readme file to install $(exec)")))

all: help
build: image

help: ## Display help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

image: ## Builds a docker image for the solution
	docker build -t sohrabkhan/python-helloworld:latest ./app

run: ## Run the app directly in a docker container. You should be able to access the app using http://localhost:8080
	docker run -d -p 8080:8080 sohrabkhan/python-helloworld

install: ## Install the kubernetes resources. Then access the python helloworld application by adding a /etc/hosts entry and browse to http://equal-experts-helloworld.com
	kubectl apply -f k8s-resources.yaml

uninstall: ## Uninstall all kubernetes resources
	kubectl delete -f k8s-resources.yaml
