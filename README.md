*Deprecated*: This Docker container uses v3 of Insight API and depends on a Bitprim fork of the BCH ABC full node.
Bitprim never released a v0.19.x fork of ABC, so the Insigh API contained in this Docker container was forked off
the network on May 15th, 2019.

# insight-docker
This repository contains a Docker Compose and Dockerfile for building
a Docker-based Bitpay Insight API server and bitcoin-abc v19.6 full node.
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
The testnet blockchain data takes up about 25GB of space.
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

  - Be sure to update the docker-compose.yml file if you'd like the blockchain
  to be stored in a different directory.

* Build the Docker images by running:

`docker-compose build`

* After the Docker image has been build, you can start it:

`docker-compose up -d`

* After the blockchain syncs, you can access the insight server at port 3001.
You can check on progress with the command `docker logs insight-bch`.

**Note**: It's important that the
[bitcoin.conf](config/testnet-example/bitcoin.conf)
file get copied to the `~/blockchain-data` directory. If it is not, bitcore
will generate it's own (incorrect) copy. If things are behaving unexpectedly,
inspect the `~/blockchain-data/bitcoin.conf` file first.
