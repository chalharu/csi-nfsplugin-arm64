FROM ubuntu AS build-env

RUN apt-get -yq update
RUN apt-get -yq install software-properties-common sudo
RUN apt-add-repository universe
RUN apt-add-repository multiverse
RUN apt-get -yq update
RUN apt-get -yq install gcc-aarch64-linux-gnu git make gcc bc device-tree-compiler u-boot-tools \
  ncurses-dev qemu-user-static wget cpio kmod squashfs-tools bison flex libssl-dev patch \
  xz-utils b43-fwcutter bzip2 ccache gawk golang
RUN apt-get -yq clean
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

ENV GOARCH=arm64
ENV GOOS=linux

RUN go get -d github.com/kubernetes-csi/drivers || true
RUN cd /root/go/src/github.com/kubernetes-csi/drivers && \
    dep ensure -vendor-only
RUN cd /root/go/src/github.com/kubernetes-csi/drivers && \
    mkdir -p _output && \
    CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o _output/nfsplugin ./app/nfsplugin

FROM arm64v8/centos:7

COPY --from=build-env /root/go/src/github.com/kubernetes-csi/drivers/_output/nfsplugin /nfsplugin

RUN yum -y install nfs-utils && yum -y install epel-release && yum -y install jq && yum clean all

ENTRYPOINT ["/nfsplugin"]
