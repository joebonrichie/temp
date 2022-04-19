include ../Makefile.inc

xml_stream:
	gprbuild $(GPRBUILD_TARGET) -P xml_stream.gpr
ifeq ($(RUN),true)
	obj/xml_stream$(EXE)
endif

clean:
	gprclean $(GPRBUILD_TARGET) -P xml_stream.gpr
	$(RM) graphics.xml

.PHONY: clean xml_stream
