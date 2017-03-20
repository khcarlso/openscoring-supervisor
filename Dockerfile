### Container for Openscoring 1.3 with model directory watch
### Dockerfile creates openscoring process with exposed port 8080, 
###   openscoring model-dir watch process, and
###   supervisord that manages both process with dashboard exposed on port 9001
### Thanks for Michal Maxian for openscoring Dockerfile
### Kevin Carlson, khcarlso@gmail.com

FROM buildpack-deps:jessie-scm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    maven\
    openjdk-7-jdk \
    unzip \
    xz-utils \
		supervisor \
		&& mkdir -p /var/log/supervisor \
		&& mkdir -p /etc/supervisor/conf.d \
  && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN cd /opt && git clone https://github.com/openscoring/openscoring.git && \
    mkdir -p /opt/openscoring/model-dir && cd /opt/openscoring && \
    mvn clean install

ADD application.conf /opt/openscoring/application.conf
ADD supervisor.conf /etc/supervisor.conf
ADD openscoring.conf /etc/supervisor/conf.d/openscoring.conf
ADD openscoring-watch.conf /etc/supervisor/conf.d/openscoring-watch.conf

EXPOSE 8080
EXPOSE 9001
ENTRYPOINT ["supervisord", "-c", "/etc/supervisor.conf"]