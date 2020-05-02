#!/bin/bash
#
# 12/04/2020 agsb@
# from https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04
#

sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"

sudo apt-get update

sudo apt-get install docker-ce

