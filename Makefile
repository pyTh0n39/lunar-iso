#
# Makefile to make ISO's
#

#
# all user configurable options are in conf/config
#
include conf/config

# need to make this defined during run-time
ISO_SOURCE = $(shell bash -c "pwd -P")

# define the location where the ISO will be generated
ISO_TARGET = $(ISO_SOURCE)/BUILD

export ISO_SOURCE ISO_TARGET ISO_VERSION ISO_CODENAME ISO_DATE ISO_CNAME ISO_KVER ISO_PVER ISO_LUNAR_MODULE

all: iso

iso: isolinux $(ISO_TARGET)/.iso
$(ISO_TARGET)/.iso:
	@echo "Generating .iso file"
	@scripts/isofs

isolinux: proper kernels memtest $(ISO_TARGET)/isolinux
$(ISO_TARGET)/isolinux:
	@echo "Generating isolinux files"
	@scripts/isolinux

proper: aaa_dev aaa_base $(ISO_TARGET)/.proper
$(ISO_TARGET)/.proper:
	@echo "Cleaning BUILD"
	@scripts/proper

aaa_dev: $(ISO_SOURCE)/aaa_dev/aaa_dev.tar.bz2
$(ISO_SOURCE)/aaa_dev/aaa_dev.tar.bz2: initrd

initrd: discover $(ISO_SOURCE)/initrd/initrd
$(ISO_SOURCE)/initrd/initrd:
	@echo "Generating initrd image"
	@scripts/initrd

discover: $(ISO_SOURCE)/discover/discover
$(ISO_SOURCE)/discover/discover:
	@echo "Generating static discover"
	@scripts/discover

kernels: $(ISO_SOURCE)/kernels/.kernels
$(ISO_SOURCE)/kernels/.kernels:
	@echo "Building precompiled kernels"
	@scripts/kernels

memtest: $(ISO_SOURCE)/memtest/memtest
$(ISO_SOURCE)/memtest/memtest:
	@echo "Generating memtest boot image"
	@scripts/memtest

aaa_base: rebuild $(ISO_SOURCE)/aaa_base/aaa_base.tar.bz2
$(ISO_SOURCE)/aaa_base/aaa_base.tar.bz2:
	@echo "Creating aaa_base.tar.bz2"
	@scripts/aaa_base

rebuild: etc $(ISO_TARGET)/.rebuild
$(ISO_TARGET)/.rebuild:
	@echo "Starting rebuild process"
	@scripts/rebuild

etc: moonbase unpack $(ISO_TARGET)/.etcf
$(ISO_TARGET)/.etcf:
	@echo "Copying miscfiles"
	@scripts/etc

moonbase: $(ISO_SOURCE)/template/moonbase.tar.bz2
$(ISO_SOURCE)/template/moonbase.tar.bz2:
	@echo "Getting a proper moonbase"
	@scripts/moonbase


unpack: dirs $(ISO_TARGET)/.unpack
$(ISO_TARGET)/.unpack:
	@echo "Unpacking binaries and copying sources"
	@scripts/unpack

dirs: init $(ISO_TARGET)/.dirs
$(ISO_TARGET)/.dirs:
	@echo "Creating LSB directory structure"
	@scripts/dirs

init: $(ISO_TARGET)/.init
$(ISO_TARGET)/.init:
	@echo "Creating BUILD root"
	@scripts/init

clean:
	umount BUILD/dev BUILD/proc &> /dev/null || true
	rm -rf BUILD aaa_base aaa_dev template/moonbase.tar.bz2

blank:
	@scripts/blank

burn:
	@scripts/burn

