FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install gperf bison flex texinfo help2man gawk libtool-bin git unzip ncurses-dev rsync zlib1g zlib1g-dev xz-utils cmake wget bzip2 g++ python3 python3-dev python3-pip python3.10-venv cpio bc virtualenv libusb-1.0 && \
    ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

# install autoconf 2.71:
RUN wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.xz && \
    tar -xf autoconf-2.71.tar.xz && \
    cd autoconf-2.71 && \
    ./configure --prefix=`pwd`/root && \
    make && \
    make install && \
    cd .. && rm autoconf-2.71.tar.xz
ENV PATH="$PATH:/app/autoconf-2.71/root/bin"

# user config:
ARG DOCKER_USER=default_user
ARG DOCKER_USERID=default_userid
# Cannot run as root, we'll just do everything else as a user
# The dialup group maybe doesn't work in Docker. Please help. Issue #10 
RUN chmod a+rwx /app && \ 
    useradd -d /app/build -u $DOCKER_USERID $DOCKER_USER && \
    mkdir build && \
    chown $DOCKER_USER:$DOCKER_USER build && \
    usermod -a -G dialout $DOCKER_USER

USER $DOCKER_USER
