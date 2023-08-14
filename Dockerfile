FROM ubuntu:22.10

RUN apt-get update &&\
    apt-get upgrade &&\
    apt-get install curl unzip -y &&\
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]