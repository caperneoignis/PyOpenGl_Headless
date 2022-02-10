FROM python:3.7.6-slim as base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update

RUN apt update && apt install -y python3 python3-pip git python-opengl xvfb xorg-dev cmake libosmesa6
RUN pip3 install pyopengl glfw
RUN mkdir /projects
RUN git clone https://github.com/glfw/glfw.git /projects/glfw

RUN cd /projects/glfw && cmake -DBUILD_SHARED_LIBS=ON . && make


RUN export PYGLFW_LIBRARY=/projects/glfw/src/libglfw.so

RUN cd ~

# Some TF tools expect a "python" binary
#RUN ln -s $(which python3) /usr/local/bin/python

# Options:
#   tensorflow
#   tensorflow-gpu
#   tf-nightly
#   tf-nightly-gpu
# Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# Installs the latest version by default.
ARG TF_PACKAGE=tensorflow
ARG TF_PACKAGE_VERSION=''
RUN python3 -m pip install --upgrade pip

#RUN curl https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-2.8.0-cp37-cp37m-manylinux2010_x86_64.whl -o tensorflow_cpu-2.8.0-cp37-cp37m-manylinux2010_x86_64.whl

RUN pip3 install tensorflow_cpu

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc
ENV PYOPENGL_PLATFORM=osmesa