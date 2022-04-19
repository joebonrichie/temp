include ../Makefile.inc

dimensioned_units:
	gprbuild $(GPRBUILD_TARGET) -P dimensioned_units.gpr
ifeq ($(RUN),true)
	$(CDir)free_fall$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P dimensioned_units.gpr

.PHONY: clean dimensioned_units
