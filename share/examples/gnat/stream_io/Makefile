include ../Makefile.inc

stream_io:
	gprbuild $(GPRBUILD_TARGET) -P stream_io_demo.gpr
ifeq ($(RUN),true)
	$(CDir)stream_io_demo$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P stream_io_demo.gpr

.PHONY: clean stream_io_demo
