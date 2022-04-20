FROM --platform=linux/amd64 alpine:3.8 

ENV KUBECTL_VERSION=1.23.0
ENV IBMCLOUD_VERSION=2.6.0

RUN  adduser -G root -D -u 1000 -g 1000 nonroot

WORKDIR "/home/nonroot"

RUN apk update && \
    apk add --no-cache bash curl git && \
    mkdir /home/nonroot/bin && \
    curl -k https://download.clis.cloud.ibm.com/ibm-cloud-cli/${IBMCLOUD_VERSION}/IBM_Cloud_CLI_${IBMCLOUD_VERSION}_amd64.tar.gz -o out.tar.gz && \
    tar xvzf out.tar.gz && \
    ./Bluemix_CLI/install_bluemix_cli && \
    ibmcloud plugin install container-service -r Bluemix && \
    ibmcloud plugin update container-registry -r Bluemix && \
    ibmcloud plugin install vpc-infrastructure -r Bluemix && \
    rm out.tar.gz && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /home/nonroot/bin && \
    chmod +x /home/nonroot/bin/kubectl

RUN echo 'export PS1="\[\e[34m\]IBM\[\e[m\]☁️  # "' > /home/nonroot/.bashrc
RUN echo 'export PATH="$PATH:/root/bin"' >> /home/nonroot/.bashrc
RUN echo 'cat /etc/motd' >> /home/nonroot/.bashrc
RUN echo 'Thank you for using the IBM Cloud-Native Docker Container. In your first login, we suggest you ibmcloud login to authenticate against the IBM cloud API.' > /etc/motd

RUN chown -R 1000:1000 /home/nonroot
USER 1000

ENTRYPOINT ["bash"]
EXPOSE 8080-8085
