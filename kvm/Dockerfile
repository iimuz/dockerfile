FROM ubuntu:18.04
LABEL maintainer iimuz

RUN set -x && \
  apt update && \
  apt upgrade -y && \
  apt install --no-install-recommends -y \
    bridge-utils \
    cpu-checker \
    libvirt-bin \
    ovmf \
    qemu-kvm \
    virtinst \
    virt-manager && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["kvm"]
