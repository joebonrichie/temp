include ../Makefile.inc

oo_interfaces:
	gprbuild $(GPRBUILD_TARGET) -P oo_interfaces.gpr
ifeq ($(RUN),true)
  ifeq ($(CYGWIN),false)
	obj\oo_interfaces$(EXE)
  else
	obj/oo_interfaces$(EXE) < oo_interfaces.input
  endif
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P oo_interfaces.gpr

.PHONY: clean oo_interfaces
