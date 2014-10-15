
FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install git-core build-essential gfortran
RUN apt-get -y install sudo
RUN apt-get -y install make cmake
RUN apt-get -y install libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
RUN apt-get -y install wget curl llvm
RUN apt-get -y install vim

RUN mkdir /tmp/openblas_build
RUN cd /tmp/openblas_build/ && wget https://github.com/xianyi/OpenBLAS/archive/v0.2.12.tar.gz && tar xfzv v0.2.12.tar.gz
RUN cd /tmp/openblas_build/OpenBLAS-0.2.12/ &&  make DYNAMIC_ARCH=1 NO_AFFINITY=1 NUM_THREADS=32 && make install && ldconfig

RUN cd /tmp && rm -rf openblas_build/

RUN useradd -m pyuser
RUN echo 'pyuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /home/pyuser
USER pyuser
ENV HOME /home/pyuser
ENV PYENVPATH $HOME/.pyenv
ENV PATH $PYENVPATH/shims:$PYENVPATH/bin:$PATH

RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

ENV PATH ~/.pyenv/shims:~/.pyenv/bin:$PATH
RUN echo 'eval "$(pyenv init -)"' >  ~/.bashrc
#RUN echo 'eval "$(pyenv virtualenv-init -)"' > ~/.bashrc
#RUN pyenv install 2.7.8
#RUN pyenv install anaconda-2.0.1

RUN pyenv global 2.7.8


