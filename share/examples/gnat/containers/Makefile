include ../Makefile.inc

all: anagram genealogy  hash  library  shapes  spellcheck  wordcount  wordfreq

clean: anagram.clean genealogy.clean  hash.clean  library.clean  shapes.clean  spellcheck.clean  wordcount.clean  wordfreq.clean

hash  library  shapes:
	gprbuild $(GPRBUILD_TARGET) -P $@/$@.gpr
ifeq ($(RUN),true)
	(cd $@ && ./$@$(EXE))
endif

# We have special execution for these ones
anagram:
	gprbuild $(GPRBUILD_TARGET) -P $@/$@.gpr
ifeq ($(RUN),true)
	(cd $@ && ./$@2$(EXE) short_dico)
endif
genealogy:
	gprbuild $(GPRBUILD_TARGET) -P $@/$@.gpr
ifeq ($(RUN),true)
	(cd $@ && ./$@$(EXE) TCS-genealogy.txt)
endif
wordcount:
	gprbuild $(GPRBUILD_TARGET) -P $@/$@.gpr
ifeq ($(RUN),true)
	(cd $@ && ./$@$(EXE) $@.xml)
endif

wordfreq:
	gprbuild $(GPRBUILD_TARGET) -P $@/$@.gpr
ifeq ($(RUN),true)
	(cd $@ && ./$@$(EXE) < wordfreq-input.txt)
endif

# We have special execution for this one
# We don't want to execute those ones because they are interactive
spellcheck:
	gprbuild $(GPRBUILD_TARGET) -P $@/$@.gpr

anagram.clean genealogy.clean  hash.clean  library.clean  shapes.clean  spellcheck.clean  wordcount.clean  wordfreq.clean:
	gprclean $(GPRBUILD_TARGET) -P $(@:%.clean=%)/$(@:%.clean=%).gpr

.PHONY: anagram genealogy  hash  library  shapes  spellcheck  wordcount  wordfreq anagram.clean genealogy.clean  hash.clean  library.clean  shapes.clean  spellcheck.clean  wordcount.clean  wordfreq.clean clean all

