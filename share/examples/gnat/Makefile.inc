# RUN controls the execution of most examples
#     RUN=true   will execute the built programs
#     RUN=false  will not execute the built programs
RUN=true

# RUN_DINERS controls the execution of the diners example
#     RUN=true   will execute the diners program
#     RUN=false  will not execute the diners program
RUN_DINERS=$(RUN)

# TARGET holds the configuration names of the compiler
#        it is mostly used to adapt the examples to special configurations
#        such as Windows (with no cygwin)
TARGET=$(shell gcc -dumpmachine)
GPRBUILD_TARGET=--target=$(TARGET)

# RM is the default delete command of the host system
RM= rm -f

# SHELL is the default command shell of the host system
SHELL=sh

# EXE is the usual executable suffix of the target system
EXE=

# CPLUSPLUS controls the build/exec of the G++ interfacing example
#        CPLUSPLUS = true  G++ interfacing example will be done
#        CPLUSPLUS = false G++ interfacing example will be done
# This variable is set when Makefile is invoked.
#   Example: make other_languages CPLUSPLUS=false

# S is the usual directory separator of the host system
S=/

# CDir is the usual denomination of the current directory
CDir=./

# PREFIX is the usual prefix for GNAT commands
PREFIX=

# CROSS indicates if a cross-compiler is used or not
CROSS=false
 
#
# Windows Specific section
#
ifneq ($(findstring mingw32,$(TARGET)),)
  # By default we assume that CYGWIN is not available
  CYGWIN=false

  # Diners output does not work right on windows
  RUN_DINERS=false

  EXE=.exe

  # if CYGWIN is not available let's adapt to CMD shell
  ifneq ($(CYGWIN), true)
    CDir=
    RM=cmd.exe /c del
    SHELL=cmd.exe
    S='\'
  endif
endif

#
# VxWorks Specific section
#
ifneq ($(findstring vxworks,$(TARGET)),)
  PREFIX=$(TARGET)-
  RUN=false
  CROSS=true
endif

#
# Plugins demo
#
ifneq ($(findstring mingw32,$(TARGET)),)
  PLUGINS=plugins
endif

ifeq ($(TARGET),i686-pc-linux-gnu)
  PLUGINS=plugins
endif

ifeq ($(TARGET),hppa1.1-hp-hpux11.00)
  PLUGINS=plugins
endif

ifeq ($(TARGET),hppa1.1-hp-hpux11.11)
  PLUGINS=plugins
endif

ifeq ($(TARGET),x86_64-pc-linux-gnu)
  PLUGINS=plugins
endif

ifeq ($(TARGET),sparc-sun-solaris2.8)
  PLUGINS=plugins
endif

ifeq ($(TARGET),i686-pc-solaris2.8)
  PLUGINS=plugins
endif
