# Creates a BCH Insight API Server and bitcoin-abc v19.6 Full Node.
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

# Clone the v0.19.x fork of the bitcoin-abc BCH full node with extra indexing
RUN git clone https://github.com/valbergconsulting/bitcore-abc
WORKDIR /home/insight/bitcore-abc
RUN git checkout 0.20.4-bitcore

# Install dependencies for building full node from source
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libminiupnpc-dev libzmq3-dev libboost-all-dev libdb++-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

# Build BCH full node
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

#Create a directory for holding blockchain data
VOLUME /home/insight/blockchain-data

RUN mkdir /home/insight/.bitcoin

# Testnet configuration file
#COPY config/testnet-example/bitcoin.conf /home/insight/.bitcoin/bitcoin.conf
# Mainnet configuration file
COPY config/mainnet-example/bitcoin.conf /home/insight/.bitcoin/bitcoin.conf

# Switch to user account.
USER insight
# Prep 'sudo' commands.
RUN echo 'password' | sudo -S pwd

# Install bitcore
RUN npm install -g bitcore

# Create bitcore project
WORKDIR /home/insight
RUN /home/insight/.npm-global/bin/bitcore create mynode-abc
WORKDIR /home/insight/mynode-abc

# Install insight API server and UI
RUN /home/insight/.npm-global/bin/bitcore install christroutner/insight-api#cash_v4 insight-ui

# Overwrite the version guard that would cause errors
COPY config/hacks/insight-api-bitcore-lib-index.js /home/insight/.npm-global/lib/node_modules/bitcore/node_modules/insight-api/node_modules/bitcore-lib/index.js
COPY config/hacks/bitcore-message-bitcore-lib-index.js /home/insight/.npm-global/lib/node_modules/bitcore/node_modules/bitcore-message/node_modules/bitcore-lib/index.js

# Create the directory architecture needed to set the bitcoin.conf file.
RUN mkdir /home/insight/.bitcore
RUN mkdir /home/insight/.bitcore/data

# Copy *testnet* config
#COPY config/testnet-example/bitcore-node.json /home/insight/mynode-abc
COPY config/mainnet-example/bitcore-node.json /home/insight/mynode-abc
COPY config/mainnet-example/bitcore-node.json /home/insight/.bitcore/bitcore-node.json

# Insight server UI
# Testnet
EXPOSE 3001
# Mainnet
#EXPOSE 3002

# ZeroMQ
EXPOSE 28331

WORKDIR /home/insight
COPY start-app.sh start-app.sh
CMD ["./start-app.sh"]

#WORKDIR /home/insight
COPY debug/dummyapp.js dummyapp.js
CMD ["node", "dummyapp.js"]
