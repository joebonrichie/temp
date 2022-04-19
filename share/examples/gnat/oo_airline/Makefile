include ../Makefile.inc

all:
	gprbuild $(GPRBUILD_TARGET) -P oo_airline
ifeq ($(RUN),true)
	$(CDir)broker$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P oo_airline

.PHONY: full1 full2 clean
