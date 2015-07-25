#!/bin/bash
#build script

#./build <kernel> - will build the kernel
#./build <mod> - will build the modified packages
#./build <l4re> - will build the l4re runtime enviornment


## Helper Functions 
##
print_help_and_exit() {
  echo "Usage: "
  echo "./build.sh kernel|mod|l4re"
  exit 0;
}


## If no arguments
##
if [ -z "$1" ]; then
  print_help_and_exit
fi


## Match arguments
##
if [ $1 == "kernel" ]; then
  # runs the L4 kernel build procedure
  cd trunk/kernel/fiasco
  make BUILDDIR=../../obj/fiasco
  cd ../../obj/fiasco
  make config
  make


elif [ $1 == "l4re" ]; then
  # build the L4re kernels
  # NOTE: having a file named broken in any package folder will
  # stop that package from being built and not throw errors
  cd trunk/src/l4
  make B=../../obj/l4/x86
  make O=../../obj/l4/x86 config
  make O=../../obj/l4/x86


elif [ $1 == "mod" ]; then
  # procedure to build the modified packages
  # each package has been divided based on the dependency
  # and the author of the package changeee
  # List of packages we have created or modified
  #dom0-main  l4re_kernel  l4sys  libac  libedft  libkproxy  moe  ned

  cd pkg
  #stark changes
  # Mr.Stark had changes in l4sys as well, thus building dom0-main first
  make O=../../trunk/obj/l4/x86 -C pkg/dom0-main
  make O=../../trunk/obj/l4/x86 -C pkg/ned
  #hauner changes
  make O=../../trunk/obj/l4/x86 -C pkg/l4sys
  make O=../../trunk/obj/l4/x86 -C pkg/libedft
  #bachmeier changes
  make O=../../trunk/obj/l4/x86 -C pkg/libkproxy
  make O=../../trunk/obj/l4/x86 -C pkg/libac
  make O=../../trunk/obj/l4/x86 -C pkg/moe
  make O=../../trunk/obj/l4/x86 -C pkg/l4re_kernel
  #kundaliya changes


else
  print_help_and_exit
fi
