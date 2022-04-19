include ../Makefile.inc

volatile_streams:
	gprbuild $(GPRBUILD_TARGET) -P volatile_streams.gpr
ifeq ($(RUN),true)
	objs/volatile_streams$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P volatile_streams.gpr

.PHONY: clean volatile_streams
