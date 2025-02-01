#!/bin/bash
set -x

echo "Updating OS and installing docker..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y curl docker.io

echo "Installing NVIDIA drivers"
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/ubuntu$(lsb_release -r -s)/libnvidia-container.list |     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |     sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo apt-get autoremove -y
sudo apt-get clean -y

echo "Enabling docker..."
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull 'ubuntu:22.04'

echo "Configuring docker to use GPUs..."
sudo nvidia-ctk runtime configure --runtime=docker

echo "Rebooting..."
sudo init 6