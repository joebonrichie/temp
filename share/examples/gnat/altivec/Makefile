include ../Makefile.inc

altivec_soft:
	gprbuild $(GPRBUILD_TARGET) -P altivec_soft.gpr
ifeq ($(RUN),true)
	obj/altivec$(EXE)
endif

altivec_hard:
	gprbuild $(GPRBUILD_TARGET) -P altivec_hard.gpr
ifeq ($(RUN),true)
	obj_hard/altivec$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P altivec_soft.gpr
	gprclean $(GPRBUILD_TARGET) -P altivec_hard.gpr

.PHONY: clean altivec_soft altivec_hard
