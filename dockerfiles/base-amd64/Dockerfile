FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:fenics-packages/fenics && \
    apt-get update && apt-get install -y fenics python3-pip && \
    rm -rf /var/lib/apt/lists/*
