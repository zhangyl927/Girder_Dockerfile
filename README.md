1. Modify girder config file:  /girder/girder/conf/girder.local.cfg
```
[global]
server.socket_host = "172.17.0.2"   # your docker ip
server.socket_port = 8080
server.thread_pool = 100
```

2. Start up services
```
# mongod
# gider serve
```

3. Start up docker
```
$ sudo docker run -it --rm --name DockerNames -p 8080:8080 -d IMAGE
```
