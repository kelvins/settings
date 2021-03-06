#!/bin/bash

PYTHON_VERSION=3.8.3
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
tar -xf Python-${PYTHON_VERSION}.tar.xz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
make -j 8
sudo make altinstall
