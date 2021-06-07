#Current version: 2.0.21
FROM emscripten/emsdk

RUN git clone --branch v1.3.1 https://github.com/xiph/opus.git
WORKDIR ./opus

RUN apt-get update \
	&& DEBIAN_FRONTENTD="noninteractive" apt-get install -y --no-install-recommends \
	autoconf \
	libtool \
	automake

ENV CFLAGS='-O3 -fPIC'
ENV CPPFLAGS='-O3 -fPIC'
RUN ./autogen.sh \
	&& emconfigure ./configure \
		--disable-intrinsics \
		--disable-rtcd \
		--disable-extra-programs \
		--disable-doc \
		--enable-static \
		--disable-stack-protector \
		--with-pic=ON \
	&& emmake make
RUN mkdir emc_out \
	&& emcc -O3 -s MAIN_MODULE=1 -s EXPORT_NAME=libopus -s MODULARIZE=1 ./.libs/libopus.a -o ./emc_out/libopus.js
WORKDIR ./emc_out
