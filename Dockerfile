# Dockerfile port of https://gist.github.com/jcmvbkbc/316e6da728021c8ff670a24e674a35e6
# wifi details http://wiki.osll.ru/doku.php/etc:users:jcmvbkbc:linux-xtensa:esp32s3wifi

# we need python 3.10 not 3.11
FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install gperf bison flex texinfo help2man gawk libtool-bin git unzip ncurses-dev rsync zlib1g zlib1g-dev xz-utils cmake wget bzip2 g++ python3 python3-dev python3-pip cpio bc virtualenv libusb-1.0 && \
    ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

# install autoconf 2.71
RUN wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.xz && \
    tar -xf autoconf-2.71.tar.xz && \
    cd autoconf-2.71 && \
    ./configure --prefix=`pwd`/root && \
    make && \
    make install
ENV PATH="$PATH:/app/autoconf-2.71/root/bin"

#COPY esp32-linux-build/* /app/
RUN chmod a+rwx /app

#USER 1000

# ct-ng cannot run as root, we'll just do everything else as a user
#RUN useradd -d /app/build -u 3232 esp32 && mkdir build && chown esp32:esp32 build
#USER esp32
# keep docker running so we can debug/rebuild :)

#USER root
#ENTRYPOINT ["tail", "-f", "/dev/null"]

# grab the files with `docker cp CONTAINER_NAME:/app/build/release/\* .`
# now you can burn the files from the 'release' folder with: 
# python esptool.py --chip esp32s3 -p /dev/ttyUSB0 -b 921600 --before=default_reset --after=hard_reset write_flash 0x0 bootloader.bin 0x10000 network_adapter.bin 0x8000 partition-table.bin
# next we can burn in the kernel and filesys with parttool, which is part of esp-idf
# parttool.py write_partition --partition-name linux --input xipImage
# parttool.py write_partition --partition-name rootfs --input rootfs.cramfs
