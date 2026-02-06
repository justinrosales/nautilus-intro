# To run inside the pod
sudo dpkg -i code_1.88.0-1712152114_amd64.deb
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install python3.8 -y
sudo apt install python3.8-distutils -y
pip3 install jupyterlab