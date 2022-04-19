include ../Makefile.inc

starter: hello demo1

hello:
	$(PREFIX)gnatmake -g hello
ifeq ($(RUN),true)
	$(CDir)hello$(EXE)
endif

demo1:
	$(PREFIX)gnatmake -g demo1
ifeq ($(RUN),true)
	$(CDir)demo1$(EXE)
endif

clean:
	$(RM) hello$(EXE) demo1$(EXE) *.o *.ali b~*
.PHONY: clean starter hello demo1
