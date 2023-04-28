FROM ubuntu:22.04

RUN mkdir /workspace
WORKDIR /workspace

COPY . .

RUN apt-get update \
	&& apt-get install --yes \
		curl \
		sudo \
        zsh

RUN curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash

RUN sudo apt -y install sysbench

# Use a noARG USERNAME=vscode
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Add non-root user and add to sudoers
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /usr/bin/zsh \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
ENV HOME /home/$USERNAME

EXPOSE 8000
