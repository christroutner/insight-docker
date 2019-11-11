#!/bin/bash
# Starts the Bitcore/Insight app inside the Docker container. It first has
# to write the bitcoin.conf file.

# Prep the sudo command
echo 'password' | sudo -S pwd

# Copy the bitcoin.conf file into the mounted blockchain-data directory.
sudo cp /home/insight/.bitcoin/bitcoin.conf /home/insight/blockchain-data
sudo cp /home/insight/.bitcoin/bitcoin.conf /home/insight/.bitcore/data/bitcoin.conf

# Display the bitcore-node.json file:
echo " "
echo "/home/insight/.bitcore/bitcore-node.json:"
cat /home/insight/.bitcore/bitcore-node.json

# Display the bitcoin.conf file
echo " "
echo "/home/insight/blockchain-data/bitcoin.conf:"
cat /home/insight/blockchain-data/bitcoin.conf

sleep 10

# Start Bitcore/Insight
/home/insight/.npm-global/bin/bitcore start
