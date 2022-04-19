include ../Makefile.inc

ifeq ($(CPLUSPLUS), true)
all: animals/main$(EXE) animals_cpp/animals$(EXE) \
 cpp_main/cpp_main$(EXE) \
 cpp_pragmas/ex6_main$(EXE) \
 import_from_c/use_of_import$(EXE)
else
all: import_from_c/use_of_import$(EXE)
endif

ifneq ($(TARGET),"")
GPRBUILD_TARGET=--target=$(TARGET)
else
GPRBUILD_TARGET=
endif

animals/main$(EXE):
	gprbuild $(GPRBUILD_TARGET) -P animals/animals.gpr
	animals/main$(EXE)

animals_cpp/animals$(EXE):
	gprbuild $(GPRBUILD_TARGET) -P animals_cpp/animals.gpr
	animals_cpp/animals$(EXE)

cpp_main/cpp_main$(EXE):
	gprbuild $(GPRBUILD_TARGET) -P cpp_main/cpp_main.gpr
	cpp_main/cpp_main$(EXE)

cpp_pragmas/ex6_main$(EXE):
	gprbuild $(GPRBUILD_TARGET) -P cpp_pragmas/cpp_pragmas.gpr
	cpp_pragmas/ex6_main$(EXE)

import_from_c/use_of_import$(EXE):
	gprbuild $(GPRBUILD_TARGET) -P import_from_c/import_from_c.gpr
ifeq ($(RUN),true)
	import_from_c/use_of_import$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P animals/animals.gpr
	gprclean $(GPRBUILD_TARGET) -P animals_cpp/animals.gpr
	gprclean $(GPRBUILD_TARGET) -P cpp_main/cpp_main.gpr
	gprclean $(GPRBUILD_TARGET) -P cpp_pragmas/cpp_pragmas.gpr
	gprclean $(GPRBUILD_TARGET) -P import_from_c/import_from_c.gpr

.PHONY: clean
