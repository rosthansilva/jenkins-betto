FROM jenkins/jenkins:lts-jdk17

USER root

ARG USER_ID=1000
ARG USER_GID=1000

# Modifica o usuário Jenkins apenas se os IDs forem diferentes de 0
RUN if [ "$USER_ID" != "0" ] && [ "$USER_GID" != "0" ]; then \
      groupmod -g ${USER_GID} jenkins && \
      usermod -u ${USER_ID} -g ${USER_GID} jenkins && \
      chown -R jenkins:jenkins ${JENKINS_HOME}; \
    fi

# Instalação do Docker CLI
# RUN apt update && apt install -y \
#     lsb-release software-properties-common apt-transport-https curl \
#     && curl -fsSL https://download.docker.com/linux/debian/gpg | tee /etc/apt/trusted.gpg.d/docker.asc > /dev/null \
#     && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
#     && apt update && apt install -y docker-ce-cli \
#     && rm -rf /var/lib/apt/lists/*

USER jenkins

# Copia os plugins para a pasta correta
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

# Instala os plugins usando jenkins-plugin-manager
RUN jenkins-plugin-cli -f  /usr/share/jenkins/ref/plugins.txt

WORKDIR $JENKINS_HOME
