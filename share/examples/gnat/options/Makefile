include ../Makefile.inc

DEMO2_SRC=src/demo2.adb src/gen_list.adb src/instr.adb src/instr-child.adb \
          include/gen_list.ads  include/instr.ads  include/instr-child.ads

STB_SRC=src/stb.adb

options: demo2_debug$(EXE) demo2_nodebug$(EXE) demo2_t$(EXE) demo2_0$(EXE) \
         demo2_1$(EXE) demo2_2$(EXE) demo2_3$(EXE) demo2$(EXE) stb$(EXE) run

demo2$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -Iinclude -Isrc -o demo2$(EXE) -D obj demo2

demo2_debug$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -f -g -Iinclude -Isrc -D obj -o demo2_debug demo2

demo2_nodebug$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -f -Iinclude -Isrc -D obj -o demo2_nodebug demo2

demo2_0$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -O0 -f -Iinclude -Isrc -D obj -o demo2_0 demo2

demo2_1$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -O1 -f -Iinclude -Isrc -D obj -o demo2_1 demo2

demo2_2$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -O2 -f -Iinclude -Isrc -D obj -o demo2_2 demo2

demo2_3$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -O3 -f -Iinclude -Isrc -D obj -o demo2_3 demo2

demo2_t$(EXE): $(DEMO2_SRC)
	$(PREFIX)gnatmake -f -Iinclude -Isrc -D obj -gnatyt -o demo2_t demo2

stb$(EXE): $(STB_SRC)
	$(PREFIX)gnatmake -I- -Iinclude -Isrc -D obj stb -bargs -E

run:
ifeq ($(RUN),true)
  ifeq ($(CYGWIN),false)
	$(CDir)demo2$(EXE)
  else
	$(CDir)demo2$(EXE)<demo2.input
  endif
endif

clean:
	$(RM) obj$(S)*.o obj$(S)*.ali demo2$(EXE) demo2_*$(EXE) stb$(EXE)

.PHONY: options clean run
