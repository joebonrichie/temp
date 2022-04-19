include ../Makefile.inc
simple_project:
	gprbuild $(GPRBUILD_TARGET) -P simple.gpr
ifeq ($(RUN_DINERS),true)
	$(CDir)diners$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P simple.gpr

.PHONY: clean simple_project
