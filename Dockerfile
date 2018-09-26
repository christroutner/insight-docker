# Creates a BCH Insight API Server and bitcoin-abc v18.0 Full Node.
# Based on this gist:
# https://gist.github.com/christroutner/d43eebbe99e155b0558f97e450451124

#IMAGE BUILD COMMANDS
FROM ubuntu:18.04
MAINTAINER Chris Troutner <chris.troutner@gmail.com>

#Update the OS and install any OS packages needed.
RUN apt-get update
RUN apt-get install -y sudo git curl nano gnupg

#Install Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs build-essential

#Create the user 'insight' and add them to the sudo group.
RUN useradd -ms /bin/bash insight
RUN adduser insight sudo

#Set password to 'password' change value below if you want a different password
RUN echo insight:password | chpasswd

#Set the working directory to be the connextcms home directory
WORKDIR /home/insight

#Setup NPM for non-root global install
RUN mkdir /home/insight/.npm-global
RUN chown -R insight .npm-global
RUN echo "export PATH=~/.npm-global/bin:$PATH" >> /home/insight/.profile
RUN runuser -l insight -c "npm config set prefix '~/.npm-global'"

# Clone the bitprim fork of the bitcoin-abc BCH full node
RUN git clone https://github.com/bitprim/bitcoin-abc
WORKDIR /home/insight/bitcoin-abc
RUN git checkout 0.18.0-bitcore

# Install dependencies for building full node from source
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libminiupnpc-dev libzmq3-dev libboost-all-dev libdb++-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

# Build BCH full node
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

#Create a directory for holding blockchain data
VOLUME /home/insight/blockchain-data

# Testnet configuration file
COPY config/testnet-example/bitcoin.conf /home/insight/blockchain-data/bitcoin.conf

# Install bitcore
RUN runuser -l insight -c "npm install -g bitcore"
