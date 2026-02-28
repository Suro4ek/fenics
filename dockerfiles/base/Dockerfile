FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get -y install locales sudo && \
    echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Set locale environment
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

COPY set-home-permissions.sh /etc/my_init.d/set-home-permissions.sh

# Set up user so that we do not run as root
# See https://github.com/phusion/baseimage-docker/issues/186
# Disable forward logging
# Add script to set up permissions of home directory on myinit
# Run ldconfig so that /usr/local/lib is in the default search
# path for the dynamic linker.
RUN groupadd docker
RUN useradd -m -s /bin/bash -G sudo,docker fenics && \
    echo "fenics:docker" | chpasswd && \
    echo "fenics ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "cat /home/fenics/WELCOME" >> /home/fenics/.bashrc && \
    chmod +x /etc/my_init.d/set-home-permissions.sh && \
    ldconfig

WORKDIR /tmp
    # install non-python dependencies - splitting these up reduces the size of individual image layers
# RUN apt-get update && \
# apt-get -y --with-new-pkgs \
#     -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" upgrade && \
# apt-get -y install \
#                    git \
#                    gcc \
#                    g++ \
#                    gfortran \
#                    cmake \
#                    openmpi-bin \
#                    libopenmpi-dev \
#                    flex \
#                    libblas-dev \
#                    liblapack-dev \
#                    swig3.0 \
#                    libeigen3-dev \
#                    libboost-dev \
#                    libboost-filesystem-dev \
#                    libboost-program-options-dev \
#                    libboost-iostreams-dev \
#                    libboost-timer-dev \
#                    libvtk7-dev \
#                    libvtk7-java \
#                    libvtk7-qt-dev \
#                    libhdf5-openmpi-dev \
#                    gmsh \
#                    environment-modules && \
# apt-get clean && \
# rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get -y install python3 python3-pip build-essential

# Install FEniCS dependencies
RUN apt-get -y install \
    cmake \
    git \
    pkg-config \
    libboost-all-dev \
    libeigen3-dev \
    libopenmpi-dev \
    openmpi-bin \
    libhdf5-openmpi-dev \
    libpetsc-real-dev \
    libslepc-real-dev \
    pybind11-dev

# Install python dependencies
RUN apt-get -y install \
    python3-scipy \
    python3-matplotlib \
    python3-numpy \
    python3-mpi4py \
    python3-petsc4py \
    python3-slepc4py \
    gmsh

# Install FEniCS 2019 from pip
RUN pip3 install --break-system-packages fenics-ffc fenics-ufl fenics-fiat fenics-dijitso

# Build DOLFIN from source
WORKDIR /tmp
RUN git clone --branch 2019.1.0.post0 https://bitbucket.org/fenics-project/dolfin.git && \
    cd dolfin && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j$(nproc) && \
    make install && \
    cd ../python && \
    pip3 install --break-system-packages . && \
    cd /tmp && rm -rf dolfin

RUN ldconfig

RUN pip3 install --break-system-packages torch

RUN apt-get install -y xvfb libgl1-mesa-dev libgl1-mesa-glx

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER root
COPY set_xvfb.sh /home/fenics/
RUN chmod +x /home/fenics/set_xvfb.sh
COPY pip.conf /home/fenics/.config/pip/

ENV FENICS_HOME /home/fenics
ENV DISPLAY=:99

USER fenics
RUN touch $FENICS_HOME/.sudo_as_admin_successful && \
    mkdir $FENICS_HOME/shared
VOLUME /home/fenics/shared

# Print something nice on entry.
COPY WELCOME $FENICS_HOME/WELCOME

WORKDIR /home/fenics
USER fenics

ENTRYPOINT ["/home/fenics/set_xvfb.sh"]
CMD ["/bin/bash","-i"]
