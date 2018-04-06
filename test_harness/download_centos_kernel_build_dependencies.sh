#!/bin/bash

# packages required by CentOS Custom Kernel Guide
# https://wiki.centos.org/HowTos/Custom_Kernel
sudo yum -y groupinstall "Development Tools"
sudo yum -y install rpm-build redhat-rpm-config asciidoc hmcaccalc perl-ExtUtils-Embed pesign xmlto
sudo yum -y install audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel
sudo yum -y install ncurses-devel newt-devel numactl-devel pciutils-devel python-devel zlib-devel

# probably arleady there, but worth forcing the dependency checks
sudo yum -y install gcc bc perl net-utils bison


# Download Kernel source
rpm -i http://vault.centos.org/7.2.1511/updates/Source/SPackages/kernel-3.10.0-327.28.3.el7.src.rpm 2>&1 | grep -v exists
