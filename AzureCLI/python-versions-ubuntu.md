# How to manage Python versions in Linux

## Downloading the Latest Python Version

Obligatory updates
```bash
$ apt update && apt upgrade -y
```

## Install Python dependencies
```bash
$ sudo apt-get install build-essential checkinstall
$ sudo apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev \
    libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
```
The lines below will download a compressed Python 3.8 archive to your /opt folder and unzip it:
* Download Python
```bash
$ cd /opt
$ sudo wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
$ sudo tar xzf Python-3.8.0.tgz
```
* Alt-Installing Python from Source
* Install from source
```bash
$ cd Python-3.8.0
$ sudo ./configure --enable-optimizations
$ sudo make altinstall
```

* Validate Python version
```bash
$ python3 --version
Python 3.8.0
```
Managing Alternative Python Installations

$ update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
$ update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2

https://hackersandslackers.com/multiple-versions-python-ubuntu/ 
------------------------

Check Python version

```bash
python3 --version # or
python3 -V
```
Check if you have different version of Python installed
```
sudo update-alternatives --config python
```



Will show you an error:

update-alternatives: error: no alternatives for python3 

You need to update your update-alternatives , then you will be able to set your default python version.

sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.4 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2

Then run :

sudo update-alternatives --config python

Set python3.6 as default.

Or use the following command to set python3.6 as default:

sudo update-alternatives  --set python /usr/bin/python3.6
https://unix.stackexchange.com/questions/410579/change-the-python3-default-version-in-ubuntu
