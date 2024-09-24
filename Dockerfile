# Define version arguments
ARG CUDA_VERSION=12.4.1
ARG CUDNN_VERSION=8
ARG UBUNTU_VERSION=22.04

# Stage 1: Base
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
#FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:deadsnakes/ppa \
 && apt update \
 && apt install -y --no-install-recommends python3.12 python3-pip git \
 && ln -sf python3 /usr/bin/python \
 && ln -sf pip3 /usr/bin/pip \
 && pip install --upgrade pip


ENV CUDA_HOME=/usr/local/cuda
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV FORCE_CUDA="1"

RUN pip install wheel packaging torch
RUN apt-get update && apt-get install -y git
# RUN apt install python3-packaging -y
# RUN pip3 install packaging

# Set the working directory
WORKDIR /app

# Copy requirements.txt file to the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

RUN pip install flash-attn #==2.6.1

# Copy the current directory contents into the container at /app
COPY . .

# Run server.py when the container launches
CMD ["python", "server.py"]
