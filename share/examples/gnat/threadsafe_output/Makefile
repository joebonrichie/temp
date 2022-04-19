include ../Makefile.inc

threadsafe_output:
	gprbuild $(GPRBUILD_TARGET) -P threadsafe_output.gpr
ifeq ($(RUN),true)
	$(CDir)demo_concurrent_printer$(EXE)
endif
ifeq ($(RUN),true)
	$(CDir)demo_inline_printer$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P threadsafe_output.gpr

.PHONY: clean threadsafe_output
