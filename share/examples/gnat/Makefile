include Makefile.inc

ALL_TARGETS =	starter options simple_project full_project xml_stream \
		oo_interfaces oo_airline containers $(PLUGINS) stream_io \
		altivec oo_sockets volatile_streams dimensioned_units \
		filesys_traversal knights_tour menace threadsafe_output

all: $(ALL_TARGETS) other_languages

$(ALL_TARGETS):
	make -C $@ $(PASS)

other_languages:
	make -C $@ -f Makefile

clean:
	$(foreach DIR,$(ALL_TARGETS), make -C $(DIR) clean $(PASS) &&) echo end
	make -C other_languages -f Makefile clean

install:
	if [ ! -d $(GNAT_ROOT)/share/gps/plug-ins ]; then \
		mkdir -p $(GNAT_ROOT)/share/gps/plug-ins;    \
	fi

.PHONY: $(ALL_TARGETS) clean other_languages
