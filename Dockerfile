FROM ubuntu:16.04

  RUN apt-get update && apt-get install -y python-pip git curl \
  	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

  ARG MONGO_PACKAGE=mongodb-org
  ARG MONGO_REPO=repo.mongodb.org
  ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}
  ENV MONGO_MAJOR 3.6
  ENV MONGO_VERSION 4.0.3

  RUN echo "deb http://$MONGO_REPO/apt/ubuntu xenial/${MONGO_PACKAGE%-unstable}/$MONGO_MAJOR multiverse" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list" \
    && apt-get update && apt-get install -y mongodb-org-server mongodb-org-shell \
    && curl -sL http://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs


  EXPOSE 8080

  RUN mkdir /data \
    && mkdir /data/db \
    && mkdir /girder \
    && mkdir /girder/logs

  RUN apt-get update && apt-get install -qy \
      gcc \
      wget \
      libpython2.7-dev \
      libldap2-dev \
      libsasl2-dev

  RUN wget http://bootstrap.pypa.io/get-pip.py && python get-pip.py

  WORKDIR /girder
  COPY girder /girder/girder
  COPY clients /girder/clients
  COPY plugins /girder/plugins
  COPY scripts /girder/scripts
  COPY grunt_tasks /girder/grunt_tasks
  COPY Gruntfile.js /girder/Gruntfile.js
  COPY setup.py /girder/setup.py
  COPY package.json /girder/package.json
  COPY README.rst /girder/README.rst

  RUN pip install --upgrade --upgrade-strategy eager --editable .[worker]
  RUN girder-install web --all-plugins

  CMD ["mongod"]
  CMD ["girder", "serve"]
