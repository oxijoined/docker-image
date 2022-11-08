FROM nvidia/cuda:11.2.0-devel

LABEL com.nvidia.volumes.needed="nvidia_driver"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    wget \
    p7zip-full \
    build-essential && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/oxijoined/rules_of_nature rules

RUN git clone https://github.com/hashcat/princeprocessor.git \
    cd princeprocessor/src && \
    make
WORKDIR /hashcat

RUN git clone https://github.com/hashcat/hashcat.git . && \
    git submodule update --init && \
    make install

