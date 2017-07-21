FROM ubuntu:16.04 as base

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm
RUN echo "export > /etc/envvars" >> /root/.bashrc && \
    echo "export PS1='\[\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" | tee -a /root/.bashrc /etc/skel/.bashrc && \
    echo "alias tcurrent='tail /var/log/*/current -f'" | tee -a /root/.bashrc /etc/skel/.bashrc

RUN apt-get update
RUN apt-get install -y locales && locale-gen en_US.UTF-8 && dpkg-reconfigure locales
ENV LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Runit
RUN apt-get install -y --no-install-recommends runit
CMD bash -c 'export > /etc/envvars && /usr/sbin/runsvdir-start'

# Utilities
RUN apt-get install -y --no-install-recommends vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc iproute python ssh rsync gettext-base

RUN apt-get install -y graphviz

RUN wget https://releases.hashicorp.com/terraform/0.9.11/terraform_0.9.11_linux_amd64.zip && \
    unzip terraform*.zip && \
    rm terraform*.zip && \
    mv terraform /usr/local/bin

FROM golang as build
RUN mkdir -p $GOPATH/src/github.com/terraform-providers
RUN cd $GOPATH/src/github.com/terraform-providers && \
    git clone https://github.com/terraform-providers/terraform-provider-kubernetes.git
RUN cd $GOPATH/src/github.com/terraform-providers/terraform-provider-kubernetes && \
    make build

FROM base
COPY --from=build /go/bin/terraform-provider-kubernetes /usr/local/bin/

ARG BUILD_INFO
LABEL BUILD_INFO=$BUILD_INFO

