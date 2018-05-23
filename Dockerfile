FROM alpine:3.7

LABEL maintainer="kuaner@gmail.com"

ENV GLIBC_VERSION 2.27-r0

# Download and install glibc ffmpeg
RUN apk add --update curl tzdata upx && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  curl -Lo ffmpeg-release-64bit-static.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz && \
  VER=`curl https://johnvansickle.com/ffmpeg/ | grep 'release:' |awk '{print $2}'` && \
  tar xvJf ffmpeg-release-64bit-static.tar.xz && \
  upx ./ffmpeg-${VER}-64bit-static/ffmpeg && \
  upx ./ffmpeg-${VER}-64bit-static/ffprobe && \
  cp ./ffmpeg-${VER}-64bit-static/ffmpeg /usr/bin/ && \
  cp ./ffmpeg-${VER}-64bit-static/ffprobe /usr/bin/ && \
  apk del curl upx && \
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/* ffmpeg-${VER}-64bit-static ffmpeg-release-64bit-static.tar.xz

ENV TZ=Asia/Shanghai