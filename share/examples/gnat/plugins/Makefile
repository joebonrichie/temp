include ../Makefile.inc

ifeq ($(TARGET),pentium-mingw32msv)
	GPRBUILDARGS=	-XOS_Name=Win32 -XExtension=dll
else
	OSNAME=	-XOS_Name=Unix

ifeq ($(TARGET),i686-pc-linux-gnu)
	GPRBUILDARGS=	$(OSNAME) -XLinker_Option=Short -XExtension=so
endif

ifeq ($(TARGET),hppa1.1-hp-hpux11.00)
	GPRBUILDARGS=	$(OSNAME) -XLinker_Option=Long -XExtension=sl
endif

ifeq ($(TARGET),hppa1.1-hp-hpux11.11)
	GPRBUILDARGS=	$(OSNAME) -XLinker_Option=Long -XExtension=sl
endif

ifeq ($(TARGET),x86_64-pc-linux-gnu)
	GPRBUILDARGS=	$(OSNAME) -XLinker_Option=Short -XExtension=so
endif

ifeq ($(TARGET),sparc-sun-solaris2.8)
	GPRBUILDARGS=	$(OSNAME) -XLinker_Option=Short -XExtension=so
endif

ifeq ($(TARGET), i686-pc-solaris2.8)
	GPRBUILDARGS=	$(OSNAME) -XLinker_Option=Short -XExtension=so
endif

endif


all:
	gprbuild $(GPRBUILDARGS) -P main
	gprbuild $(GPRBUILDARGS) -P base
	gprbuild $(GPRBUILDARGS) -P clocks
	gprbuild $(GPRBUILDARGS) -P gauges
	gprbuild $(GPRBUILDARGS) -P speedometers

clean:
	gprclean -P main
	gprclean -P base
	gprclean -P clocks
	gprclean -P gauges
	gprclean -P speedometers

run:
	PATH=$$PATH:lbase .$(S)demo
show:
	echo $(TARGET)
.PHONY: all clean run
