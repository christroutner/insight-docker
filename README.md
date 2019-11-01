
# insight-docker
This repository contains a Docker Compose and Dockerfile for building
a Docker-based Bitpay Insight API server and bitcoin-abc v0.20.4 full node.
This Dockerfile is based on
[this gist](https://gist.github.com/christroutner/d43eebbe99e155b0558f97e450451124)
walking through the setup of a BCH Insight server. At the moment, an Insight
server is required by
[rest.bitcoin.com](https://github.com/Bitcoin-com/rest.bitcoin.com)
API server.

This branch targets BCH **mainnet**.

## Installation
These directions are geared at Ubuntu 18.04 OS with at least 2GB of RAM,
and a non-root user with sudo privledges.

Your mileage may vary.

1. It's always a good idea to add
[swap space](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04)
to a new system. I recommend 8GB of swap typically.

2. Install Docker on the host system. Steps 1 and 2 in
[this tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)
shows how to install Docker on a Ubuntu system.

3. Install Docker Compose too. [This tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04) shows how to do so on a Ubuntu system.

4. Clone this repository:

`git clone https://github.com/christroutner/insight-docker && cd insight-docker`

  - Checkout the appropriate branch with `git checkout <branch>`

* Create directory to store the blockchain. For example:

`mkdir ~/tmp`

  - Update the docker-compose.yml file to point to the directory where you want the blockchain data stored.

* Download and run the Docker image:

`docker-compose up -d`

* After the blockchain syncs, you can access the insight server at port 3002.
You can check on progress with the command `docker logs insight-mainnet`.

**Note**: It's important that the
[bitcoin.conf](config/testnet-example/bitcoin.conf)
file get copied to the `~/blockchain-data` directory. If it is not, bitcore
will generate it's own (incorrect) copy. If things are behaving unexpectedly,
inspect the `~/blockchain-data/bitcoin.conf` file first.
