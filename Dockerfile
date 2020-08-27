FROM debian:stretch-slim

RUN apt-get update && apt-get install curl -y

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

RUN chmod +x ./kubectl

RUN  mv ./kubectl /usr/local/bin/kubectl

WORKDIR /app/

COPY . .

RUN chmod 777 entrypoint.sh

ENTRYPOINT bash entrypoint.sh default myPod error
