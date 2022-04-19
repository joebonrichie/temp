
include ../Makefile.inc

oo_sockets:
	gprbuild $(GPRBUILD_TARGET) -P oo_sockets.gpr
ifeq ($(RUN),true)
	.$(S)oo_sockets$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P oo_sockets.gpr

.PHONY: clean oo_sockets
