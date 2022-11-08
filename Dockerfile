FROM nvidia/cuda:11.2.0-devel

LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Unic0rn28/hashcat-rules unicorn
RUN git clone https://github.com/n0kovo/hashcat-rules-collection rules

RUN git clone https://github.com/hashcat/princeprocessor . && \
    cd princeprocessor/src && \
    make

WORKDIR /hashcat

RUN git clone https://github.com/hashcat/hashcat.git . && \
    git submodule update --init && \
    make install
