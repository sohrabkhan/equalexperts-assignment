# Equal Experts Assignment

## By: Sohrab Khan
## Mob: 07944336953
## Email: sohrab@sohrabkhan.com


# Assignment Details
Assignment selected: Minikube
Detail:
Write a simple hello world application in any one of these languages: Python, Ruby, Go. Build the application within a Docker container and then load balance the application within minikube. You are not required to automate the installation of minikube on the host machine.

## Pre-requisites
Ensure you've the following installed:
* Helm CLI
* Kubectl CLI
* Minikube
* Docker

### Important
1. Get the IP address of minikube by running:
```
minikube ip
```

2. Add it your hosts file like below:
```
<IP ADDRESS>     equal-experts-helloworld.com
```

Note:
On Linux / Mac the hosts file is located at:
```
/etc/hosts
```

On Windows the hosts file is located at:
```
C:\Windows\System32\drivers\etc\hosts
```

## Installation
To install the supplied helm chart run the following command:
```
make install
```

To build the Docker image for the python app run the following command from the project root directory:
```
make build
```

To run the docker image locally without minikube run the following command:
```
make run
```

If you need any help run the following command:

```
make help
```

## Running the solution
It is important to have minikube installed and running on your computer, the /etc/hosts entry in place and any other 
dependencies are installed as listed in the pre-requisites section above. 

Run the following command to install the solution on Minikube:
```
make install
```

Wait for the pods to download the container images and become ready and running.

Next open up a browser and enter the address: http://equal-experts-helloworld.com.
You should get the "Hello World!" page in response.

## Directory Structure
├── Makefile

├── README.md

├── architecture.png

├── app

│   ├── Dockerfile

│   ├── __init__.py

│   ├── main.py

│   ├── requirements.txt

│   └── uwsgi.ini

├── helloworld-chart

│   ├── Chart.yaml

│   ├── charts

│   ├── template.yaml

│   ├── templates

│   │   ├── NOTES.txt

│   │   ├── _helpers.tpl

│   │   ├── deployment.yaml

│   │   ├── hpa.yaml

│   │   ├── ingress.yaml

│   │   ├── service.yaml

│   │   ├── serviceaccount.yaml

│   │   └── tests

│   │       └── test-connection.yaml

│   └── values.yaml

### Makefile
A makefile has been provided which helps in running the most complex commands much easier.

### App/
This directory contains the Python Hellow World App

### Helloworld-chart
This directory contains the helm chart with Kubernetes resources


## Application
I chose to create the python web application using Flask framework because it's a very light weight and requires minimal
code to create a Python Web application.

A requirements.txt file is provided which helps in the installation of dependencies.

## Application Server
A production ready Python web application requires an application server. I've chosen uwsgi which is the recommended 
application server for Flask.

A uwsgi.ini file is provided in the app folder where I've set all the minimum necessary configuration that is required 
for serving the Flask application. 

## Docker Container
A Dockerfile is provided inside the app folder from which the Docker image is created. I've used python3.9 as the base 
image because I wanted to use the latest and greatest version of python and it's the official offering.

The build process copies the application to the /app folder in the image, set that folder as the workdir and then 
installs all dependencies found in the requirements.txt file.

As an entry point the "uswgi" application is used. 

For command arguments the `--ini uwsgi.ini` is used.

## Helm Chart
A minimal helm chart is used for hosting the static application. A minimal helm chart was created using the command:
```
helm create helloworld-chart
```
This chart contained alot of extra configuration which has been removed to keep the chart as simple as possible.

## Architecture
The architecture is kept as simple as possible but not compromising on DevOps principles and practices.

A Deployment Kubernetes resource is used for the application as the application is stateless. In case the application
was stateful we would have used Statefulset. A minimum of 2 replicas are used for the deployment which means that at a 
minimum 2 pods would be used to serve the application, thereby making the application highly available, scalable and 
more resiliant. A deployment update strategy of Rolling Update is used, which would mean that even during an update at 
the application should not experience any downtime.

To offer a production like experience we need a hosts entry to be set as explained in the pre-requisites section above.

The following is how the flow of request from Browser to application happens:
1. A browser is opened and given the address http://equal-experts-helloworld.com to navigate to.
2. The first location where the DNS resolution is checked is the /etc/hosts file where an entry for the DNS record is found. The hosts file return the IP address for the DNS record to the browser.
3. The browser can now send the HTTP Get request to the Minikube where an Ingress resource resides containing the target for equal-experts-helloworld.com.
4. The target for the ingress host section is the service which is pointing to the Deployment and contains the addresses of all pods of the Deployment.
5. The Service ensures that it contain the addresses of only the pods that are ready and running, so in case any pod is unhealthy that pod is not listed. The HTTP GET request lands on each of the pod.

![alt text](architecture.png)

## Uninstall
After checking the solution it is important to cleanup any used resources. Run the following commands to cleanup all 
resources that are created by this assignment:

1. Uninstall helm chart
```
make uninstall
```

2. Stop any running docker container if launched:
```
docker stop $(docker ps -a | grep sohrabkhan/python-helloworld | awk '{print $1}')
```

3. Now remove any stopped containers, unused images and unused networks:
```
docker system prune
```
