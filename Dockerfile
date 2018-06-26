FROM ubuntu AS build-env

RUN apt-get -yq update
RUN apt-get -yq install software-properties-common sudo
RUN apt-add-repository universe
RUN apt-add-repository multiverse
RUN apt-get -yq update
RUN apt-get -yq install gcc-aarch64-linux-gnu git make gcc bc device-tree-compiler u-boot-tools \
  ncurses-dev qemu-user-static wget cpio kmod squashfs-tools bison flex libssl-dev patch \
  xz-utils b43-fwcutter bzip2 ccache gawk golang curl
RUN apt-get -yq clean
RUN mkdir -p /root/go/bin
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

ENV GOARCH=arm64
ENV GOOS=linux

RUN go get -d github.com/kubernetes-csi/drivers || true
RUN cd /root/go/src/github.com/kubernetes-csi/drivers && \
    /root/go/bin/dep ensure -vendor-only
RUN cd /root/go/src/github.com/kubernetes-csi/drivers && \
    mkdir -p _output && \
    CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o _output/nfsplugin ./app/nfsplugin
RUN cd / && \
    wget https://github.com/multiarch/qemu-user-static/releases/download/v2.12.0/x86_64_qemu-aarch64-static.tar.gz && \
    tar zxvf x86_64_qemu-aarch64-static.tar.gz

FROM arm64v8/alpine:3.7

COPY --from=build-env /root/go/src/github.com/kubernetes-csi/drivers/_output/nfsplugin /nfsplugin
COPY --from=build-env /qemu-aarch64-static /usr/bin/qemu-aarch64-static

RUN apk --no-cache add nfs-utils jq

ENTRYPOINT ["/nfsplugin"]
