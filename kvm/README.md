# docker-kvm

kvm image

## Usage

```sh
$ cd sample_win10
$ mkdir _mnt
$ dd if=/dev/zero of=_mnt/primary.raw bs=10M count=8k  # 80GB
# get win10 install iso
# get virtio driver
$ docker-compose up -d
# link ip:5900 using spice
```

if you want to use GPU device, use following option in docker-compose.yml.
change device id(01:00.0 and 01:00.1) to your environment.

```diff
= command: >

-   -vga qxl
+   -vga none
+   -nographic

-   -spice port=5900,disable-ticketing,agent-mouse=off

+   -device vfio-pci,host=01:00.0,multifunction=on,x-vga=on
+   -device vfio-pci,host=01:00.1
```
