# netcat

[![Current version](https://img.shields.io/docker/v/gerwazy102/netcat?sort=semver&style=plastic)](https://hub.docker.com/r/gerwazy102/netcat)
[![Build status](https://img.shields.io/github/actions/workflow/status/gerwazy102/docker-netcat/release.yml)](https://hub.docker.com/r/gerwazy102/netcat)

Simple Alpine image for running netcat (`nc`).

Use this when you don't have netcat installed on your system or you want to use this image as a
base for simple service demos.

## Example using the host network

Start a netcat server in one terminal

```bash
docker run -t --rm --network=host --name=ncs gerwazy102/netcat -vl 8888
```

Note: we use the host network stack (`host`) which means that port `8888` in the
container is available on port `8888` of the host machine. Since we are using the host
network stack directly it is not necessary to explicitly "publish" the port to the host
network (using the `-p|--publish` option). In any case, the netcat command itself still
needs to be told which port it is supposed to listen to, so `8888` is supplied as the
argument to the default process for the container (which is `netcat`) created by the
`gerwazy102/netcat` image at the end of the `docker run` command.

Send a message to the server from another terminal

```bash
docker run -i --rm --network=host gerwazy102/netcat localhost 8888 hello # will see hello echoed at the other terminal
```

Here, supply `localhost` and `8888` as the host and port arguments to the default
command running in the container (`netcat`) created from the `gerwazy102/netcat`
image. Remember, the host is `localhost` (or `127.0.0.1`) because we started a netcat listener in
another container attached to the `host` network.

> *TIP*

You can set aliases in your shell configuration to reduce typing:

```bash
alias ncs="docker run -t --rm --network=host --name=ncs gerwazy102/netcat -vl"
alias nc="docker run -i --rm --network=host --name=nc gerwazy102/netcat localhost"
```

Then the example above looks like this:

Start netcat server in one terminal

```bash
ncs 8888
```

Send a message from another terminal

```bash
echo "hello world" | nc 8888
```

To kill both containers from yet another terminal

```bash
docker rm -f nc ncs
```

## Example with a dedicated network

Create a bridge network

We will use a dedicated network for two containers to communicate with each other using netcat
for this example. By using a dedicated network, it is not necessary to publish ports on `localhost`.

```bash
docker network create --driver bridge demonet
```

Start a netcat server in one terminal

```bash
docker run -t --rm --network=demonet --name=ncs gerwazy102/netcat -vl 8888
```

Note that although we did not publish the port to localhost (`docker run -p` option),
netcat itself still needs to be told which port to listen on (in this case, port `8888`).

Send a message to the server from another terminal

```bash
docker run -i --rm --network=demonet gerwazy102/netcat ncs 8888 hello # will see hello echoed at the other terminal
```

Note that when we run the container using the `gerwazy102/netcat` image, the default
entrypoing is the `nc` command, for which we supply both the host to connect to (`ncs` on the bridget network) and the port (`8888`).

> *TIP*

You can set aliases in your shell configuration to reduce typing:

```bash
alias ncs="docker run -t --rm --network=demonet --name=ncs gerwazy102/netcat -vl"
alias nc="docker run -i --rm --network=demonet --name=nc gerwazy102/netcat ncs"
```

Then the example above looks like this:

Start netcat server in one terminal

```bash
ncs 8888
```

Send a message from another terminal

```bash
echo "hello world" | nc 8888
```

To kill both containers from yet another terminal

```bash
docker rm -f nc ncs
```
