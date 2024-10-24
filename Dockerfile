FROM alpine:3.14
RUN apk --no-cache add curl tar
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.34-r0

RUN set -ex && \
    apk --update add libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

RUN mkdir -p /root/bin
RUN curl -L -o /root/bin/chef.tar.gz https://github.com/Zheoni/cooklang-chef/releases/download/v0.9.1/chef-x86_64-unknown-linux-gnu.tar.gz
RUN cd /root/bin && tar -zxf chef.tar.gz && chmod u+x chef
RUN mkdir -p /root/recipes
COPY bread /root/recipes/bread
COPY dinner /root/recipes/dinner
COPY drinks /root/recipes/drinks
RUN ls /root/bin
RUN mkdir /root/recipes/.cooklang
RUN cd /root/recipes && ls && /root/bin/chef serve --host
