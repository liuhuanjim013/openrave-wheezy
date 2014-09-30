FROM debian:wheezy
MAINTAINER Huan Liu <liuhuanjim013@gmail.com>

##################
# Debian packages
##################

RUN apt-get update

# openrave dependency
RUN apt-get -y --force-yes --no-install-recommends install liblapack-dev libjpeg8-dev libogg-dev libpng12-dev libqhull-dev libqrupdate1 libqt4-scripttools libsimage-dev  qt4-dev-tools libhdf5-serial-dev python-h5py libpcre++-dev python-matplotlib libsoqt4-dev python-empy libxml2-dev

# boost
RUN apt-get -y --force-yes --no-install-recommends install libboost-dev libboost-python-dev libboost-filesystem-dev libboost-iostreams-dev libboost-math-dev libboost-program-options-dev libboost-regex-dev libboost-random-dev libboost-serialization-dev libboost-signals-dev libboost-thread-dev libboost-wave-dev 

# git
RUN apt-get -y --force-yes --no-install-recommends install git-core
RUn git config --global http.sslVerify false

# build
RUN apt-get -y --force-yes --no-install-recommends install cmake make wget bzip2 file

#####################
# Build from sources
#####################

ENV SOURCE_DIR /src
ENV BUILD_DIR /build
RUN mkdir -p $SOURCE_DIR
RUN mkdir -p $BUILD_DIR

# collada-dom
ENV COLLADA_DOM_SOURCE_DIR $SOURCE_DIR/collada-dom
ENV COLLADA_DOM_BUILD_DIR $BUILD_DIR/collada-dom
RUN git clone https://github.com/rdiankov/collada-dom.git $COLLADA_DOM_SOURCE_DIR
RUN cd $COLLADA_DOM_SOURCE_DIR && git checkout b67e4e68d302d28454265ee7bd58cc692333a625
RUN mkdir -p $COLLADA_DOM_BUILD_DIR
RUN cd $COLLADA_DOM_BUILD_DIR && cmake -DCMAKE_BUILD_TYPE=Release -DOPT_DOUBLE_PRECISION=ON $COLLADA_DOM_SOURCE_DIR
RUN cd $COLLADA_DOM_BUILD_DIR && make -j4
RUN cd $COLLADA_DOM_BUILD_DIR && make install

# libccd
ENV LIBCCD_SOURCE_DIR $SOURCE_DIR/libccd
ENV LIBCCD_BUILD_DIR $BUILD_DIR/libccd
RUN git clone https://github.com/danfis/libccd.git $LIBCCD_SOURCE_DIR
RUN cd $LIBCCD_SOURCE_DIR && git checkout 2ddebf8917da5812306f74520d871ac8d8c1871e
RUN mkdir -p $LIBCCD_BUILD_DIR
RUN cd $LIBCCD_BUILD_DIR && cmake -DCMAKE_BUILD_TYPE=Release $LIBCCD_SOURCE_DIR
RUN cd $LIBCCD_BUILD_DIR && make -j4
RUN cd $LIBCCD_BUILD_DIR && make install

# opende
ENV OPENDE_SOURCE_DIR $SOURCE_DIR/ode-0.12
ENV OPENDE_BUILD_DIR $BUILD_DIR/opende
RUN wget http://downloads.sourceforge.net/project/opende/ODE/0.12/ode-0.12.tar.bz2 -O $SOURCE_DIR/ode-0.12.tar.bz2
RUN tar xf $SOURCE_DIR/ode-0.12.tar.bz2 -C $SOURCE_DIR
RUN mkdir -p $OPENDE_BUILD_DIR
RUN cd $OPENDE_BUILD_DIR && $OPENDE_SOURCE_DIR/configure --enable-libccd --with-cylinder-cylinder=libccd --with-drawstuff=none --with-trimesh=opcode --enable-new-trimesh --disable-demos --enable-shared --with-arch=nocona --enable-release --enable-malloc --enable-ou --disable-asserts --with-pic --enable-double-precision
RUN cd $OPENDE_BUILD_DIR && make -j4
RUN cd $OPENDE_BUILD_DIR && make install

# openrave
ENV OPENRAVE_SOURCE_DIR $SOURCE_DIR/openrave
ENV OPENRAVE_BUILD_DIR $BUILD_DIR/openrave
RUN git clone https://github.com/rdiankov/openrave.git $OPENRAVE_SOURCE_DIR
RUN cd $OPENRAVE_SOURCE_DIR && git fetch origin && git checkout 15e5c7c63f2f45603d2ab647027310f508d66b70
RUN mkdir -p $OPENRAVE_BUILD_DIR
RUN cd $OPENRAVE_BUILD_DIR && cmake -DCMAKE_BUILD_TYPE=Release -DODE_USE_MULTITHREAD=ON -DOPT_IKFAST_FLOAT32=OFF $OPENRAVE_SOURCE_DIR
RUN cd $OPENRAVE_BUILD_DIR && make -j4
RUN cd $OPENRAVE_BUILD_DIR && make install -j4
