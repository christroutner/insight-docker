#!/bin/bash
# Starts the Bitcore/Insight app inside the Docker container. It first has
# to write the bitcoin.conf file.

# Prep the sudo command
echo 'password' | sudo -S pwd

# Copy the bitcoin.conf file into the mounted blockchain-data directory.
sudo cp /home/insight/.bitcoin/bitcoin.conf /home/insight/blockchain-data

# Start Bitcore/Insight
/home/insight/.npm-global/bin/bitcore start
