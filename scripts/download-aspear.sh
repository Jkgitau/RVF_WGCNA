#!/bin/bash

## How to install ascp, in a gist.
## Script downloaded on 2020-12-12 from https://gist.github.com/mfansler/71f09c8b6c9a95ec4e759a8ffc488be3

## Check for latest link: http://downloads.asperasoft.com/en/downloads/8?list
wget -qO- https://download.asperasoft.com/download/sw/connect/3.9.8/ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.tar.gz | tar xvz

## run it
chmod +x ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.sh
./ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.sh

# add environment variable (as per http://bioinfostar.com/2017/12/24/How-to-download-SRA-data-en/)
echo 'export PATH=~/.aspera/connect/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# clean up
rm ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.sh
