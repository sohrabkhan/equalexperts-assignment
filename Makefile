## Equal Experts Assignment

.PHONY: all

EXECUTABLES = docker helm kubectl
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

install: ## Install the helm chart
	helm upgrade --install equalexperts ./helloworld-chart -f ./helloworld-chart/values.yaml

uninstall:
	helm uninstall equalexperts

template: ## Create a template file
	helm template ./helloworld-chart/ -n dev -f ./helloworld-chart/values.yaml > ./helloworld-chart/template.yaml