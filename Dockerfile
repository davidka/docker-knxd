FROM debian

MAINTAINER David Hahn "davidka.h@gmail.com"

# install build tools and get the source code
RUN apt-get update

RUN apt-get install -y git-core wget build-essential debhelper cdbs autotools-dev autoconf automake libtool pkg-config && \
    libusb-1.0-0-dev base-files debianutils libsystemd-dev libsystemd-daemon-dev base-files dh-systemd init-system-helpers && \
    git clone https://github.com/knxd/knxd.git

# knxd requires libpthsem which unfortunately isn't part of Debian
RUN wget https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz && \
    tar xzf pthsem_2.0.8.tar.gz  && \
    cd pthsem-2.0.8 && dpkg-buildpackage -b -uc && \
    cd .. && \
    dpkg -i libpthsem*.deb


# build+install knxd itself
RUN cd knxd && \
    dpkg-buildpackage -b -uc && \
    cd .. && \
    dpkg -i knxd_*.deb knxd-tools_*.deb

EXPOSE  4720 6720 3671/udp