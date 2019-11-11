
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

## Background
Insight API was originally created by [BitPay](https://bitpay.com/). It has since
been deprecated and is no longer maintained by them. The technology was rebranded
as [Bitcore Node](https://github.com/bitpay/bitcore/tree/master/packages/bitcore-node).

The original Insight API required a specially adapted full node. The BCH full node
has been maintained by Bitcoin.com for the last several forks, but the community
is actively trying to depricate this indexer.

**Do not use plan to use this indexer in the future.** Here are research notes to
some open source indexer alternatives:
- [Blockbook by Trezor](https://troutsblog.com/research/bitcoin-cash/blockbook)
- [Bitcore Node by Bitpay](https://troutsblog.com/research/bitcore-node-insight-api)
- [Flowee Indexer](https://flowee.org/indexer/)


## Installation
These directions are geared at Ubuntu 18.04 OS with at least 2GB of RAM,
and a non-root user with sudo privledges.

Your mileage may vary.

- It's always a good idea to add
[swap space](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04)
to a new system. I recommend 8GB of swap typically.

- Install Docker on the host system. Steps 1 and 2 in
[this tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)
shows how to install Docker on a Ubuntu system.

- Install Docker Compose too. [This tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04) shows how to do so on a Ubuntu system.

- Clone this repository:

`git clone https://github.com/christroutner/insight-docker && cd insight-docker`

  - Checkout the appropriate branch with `git checkout <branch>`

* Create directory to store the blockchain. For example:

`mkdir ~/tmp`

  - Update the docker-compose.yml file to point to the directory where you want the blockchain data stored.

* Download and run the Docker image:

`docker-compose up -d`

- Because the current implementation of Insight is a hack on top of a hack on top of hack,
the only functional startup method is leaves a lot to be desired:

- enter the contain with a bash shell: `docker exec -it insight-mainnet bash`
- run the bash shell script directly (no nohup): `./start-app.sh`
- close the terminal window (don't stop the app or exit the container)

- You can always stop the container with: `docker-compose down`

- After the blockchain syncs, you can access the insight server at port 3002.


**Note**: It's important that the
[bitcoin.conf](config/testnet-example/bitcoin.conf)
file get copied to the `~/blockchain-data` directory. If it is not, bitcore
will generate it's own (incorrect) copy. If things are behaving unexpectedly,
inspect the `~/blockchain-data/bitcoin.conf` file first.
