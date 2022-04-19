include ../Makefile.inc

ifeq ($(CROSS),false)
  FULL_PROJECT_TARGETS = full1 full2
else
  FULL_PROJECT_TARGETS = full1
endif

full_project: full1 full2

full1:
	gprbuild $(GPRBUILD_TARGET) -P full1.gpr
ifeq ($(RUN),true)
	bin$(S)debug$(S)text_io_example$(EXE)
	bin$(S)debug$(S)tef$(EXE)
	bin$(S)debug$(S)tgef$(EXE)
endif
	gprbuild $(GPRBUILD_TARGET) -f -XBUILD=release_optimized -P full1.gpr

full2:
	gprbuild $(GPRBUILD_TARGET) -P full2.gpr
ifeq ($(RUN),true)
	prog$(S)debug$(S)test_cl$(EXE)
endif
	gprbuild $(GPRBUILD_TARGET) -f -XBUILD=release_optimized -P full2.gpr

clean:
	gprclean $(GPRBUILD_TARGET) -P full1.gpr
	gprclean $(GPRBUILD_TARGET) -f -XBUILD=release_optimized -P full1.gpr
	gprclean $(GPRBUILD_TARGET) -P full2.gpr
	gprclean $(GPRBUILD_TARGET) -f -XBUILD=release_optimized -P full2.gpr

.PHONY: full1 full2 clean
