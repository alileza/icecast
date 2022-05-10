FROM debian:stable-slim

RUN apt-get update -y 
RUN apt-get install -y wget unzip
RUN apt-get install -y libtool
RUN apt-get install -y pkgconf
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libvorbis-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y libxslt1-dev
RUN apt-get install -y m4
RUN apt-get install -y automake
RUN apt-get install -y autoconf

RUN cd /tmp && \
    wget https://github.com/xiph/Icecast-Server/archive/refs/tags/v2.4.3.zip && \
    mkdir /src && \
    unzip -d /src /tmp/v2.4.3.zip && \
    mv /src/Icecast-Server-2.4.3/* /src

WORKDIR /src


RUN ls && mv configure.in configure.ac

RUN libtoolize --automake
RUN aclocal
RUN autoheader
RUN autoreconf -fi
RUN automake --add-missing

RUN ./configure --enable-ipv6
RUN make
RUN make install

RUN groupadd -g 1000 icecast && useradd -u 1000 -g icecast -s /bin/sh icecast

RUN mkdir -p /var/log/icecast/ /var/lib/icecast/ 
RUN chown -R icecast:icecast /var/log/icecast/ /var/lib/icecast/

ENTRYPOINT [ "icecast" ]