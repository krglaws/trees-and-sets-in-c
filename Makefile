
CC := gcc
CFLAGS := -fPIC 

SRC := src
INC := src/include
SBIN := src/bin

TEST := tests
TBIN := tests/bin

INCLOC := /usr/include/kylestructs
LIBLOC := /usr/lib/

default: all


# compile sources

HASHDEPS := $(SRC)/hash.c $(INC)/hash.h
HASHTARG := $(SBIN)/hash.o

$(HASHTARG): $(HASHDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


DATACONTDEPS := $(SRC)/datacont.c $(INC)/datacont.h
DATACONTTARG := $(SBIN)/datacont.o

$(DATACONTTARG): $(DATACONTDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


TREESETNODEDEPS := $(SRC)/treesetnode.c $(INC)/treesetnode.h
TREESETNODETARG := $(SBIN)/treesetnode.o

$(TREESETNODETARG): $(TREESETNODEDEPS) 
	$(CC) -c $< -o $@ $(CFLAGS)


TREESETDEPS := $(SRC)/treeset.c $(INC)/treeset.h
TREESETTARG := $(SBIN)/treeset.o

$(TREESETTARG): $(TREESETDEPS) 
	$(CC) -c $< -o $@ $(CFLAGS)


HASHSETDEPS := $(SRC)/hashset.c $(INC)/hashset.h
HASHSETTARG := $(SBIN)/hashset.o

$(HASHSETTARG): $(HASHSETDEPS) 
	$(CC) -c $< -o $@ $(CFLAGS)


LISTNODEDEPS := $(SRC)/listnode.c $(INC)/listnode.h
LISTNODETARG := $(SBIN)/listnode.o

$(LISTNODETARG): $(LISTNODEDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


TREEMAPNODEDEPS := $(SRC)/treemapnode.c $(INC)/treemapnode.h
TREEMAPNODETARG := $(SBIN)/treemapnode.o

$(TREEMAPNODETARG): $(TREEMAPNODEDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


TREEMAPDEPS := $(SRC)/treemap.c $(INC)/treemap.h
TREEMAPTARG := $(SBIN)/treemap.o

$(TREEMAPTARG): $(TREEMAPDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


HASHMAPDEPS := $(SRC)/hashmap.c $(INC)/hashmap.h
HASHMAPTARG := $(SBIN)/hashmap.o

$(HASHMAPTARG): $(HASHMAPDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)



# compile tests

TESTDEPS := $(DATACONTTARG) $(HASHTARG)
DATACONTTESTTARG := $(TBIN)/datacont_tests.out

$(DATACONTTESTTARG): $(TEST)/datacont_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS += $(TREESETNODETARG)
TREESETNODETESTTARG := $(TBIN)/treesetnode_tests.out

$(TREESETNODETESTTARG): $(TEST)/treesetnode_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS += $(TREESETTARG)
TREESETTESTTARG := $(TBIN)/treeset_tests.out

$(TREESETTESTTARG): $(TEST)/treeset_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS += $(HASHSETTARG)
HASHSETTESTTARG := $(TBIN)/hashset_tests.out

$(HASHSETTESTTARG): $(TEST)/hashset_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS := $(DATACONTTARG) $(HASHTARG) $(LISTNODETARG)
LISTNODETESTTARG := $(TBIN)/listnode_tests.out

$(LISTNODETESTTARG): $(TEST)/listnode_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS += $(TREEMAPNODETARG)
TREEMAPNODETESTTARG := $(TBIN)/treemapnode_tests.out

$(TREEMAPNODETESTTARG): $(TEST)/treemapnode_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS += $(TREEMAPTARG)
TREEMAPTESTTARG := $(TBIN)/treemap_tests.out

$(TREEMAPTESTTARG): $(TEST)/treemap_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


TESTDEPS += $(HASHMAPTARG)
HASHMAPTESTTARG := $(TBIN)/hashmap_tests.out

$(HASHMAPTESTTARG): $(TEST)/hashmap_tests.c $(TESTDEPS)
	$(CC) -g $^ -o $@


.PHONY: run_tests
run_tests: tests
	./runtests.sh


.PHONY: tests
tests: $(DATACONTTESTTARG) $(TREESETNODETESTTARG) $(TREESETTESTTARG) $(HASHSETTESTTARG)\
	$(LISTNODETESTTARG) $(TREEMAPNODETESTTARG) $(TREEMAPTESTTARG) $(HASHMAPTESTTARG)
	@echo Finished building tests.


STATICLIB := libkylestructs.a
$(STATICLIB): $(HASHTARG) $(DATACONTTARG) $(TREESETNODETARG) $(TREESETTARG) $(HASHSETTARG)\
	$(LISTNODETARG) $(TREEMAPNODETARG) $(TREEMAPTARG) $(HASHMAPTARG)
	ar rcs $(STATICLIB)\
	       	$(HASHTARG)\
		$(DATACONTTARG)\
		$(TREESETNODETARG)\
		$(TREESETTARG)\
		$(HASHSETTARG)\
		$(LISTNODETARG)\
		$(TREEMAPNODETARG)\
		$(TREEMAPTARG)\
		$(HASHMAPTARG)


DYNAMICLIB := libkylestructs.so
$(DYNAMICLIB): $(HASHTARG) $(DATACONTTARG) $(TREESETNODETARG) $(TREESETTARG) $(HASHSETTARG)\
	$(LISTNODETARG) $(TREEMAPNODETARG) $(TREEMAPTARG) $(HASHMAPTARG)
	gcc -shared -o $(DYNAMICLIB)\
		$(HASHTARG)\
		$(DATACONTTARG)\
		$(TREESETNODETARG)\
		$(TREESETTARG)\
		$(HASHSETTARG)\
		$(LISTNODETARG)\
		$(TREEMAPNODETARG)\
		$(TREEMAPTARG)\
		$(HASHMAPTARG)


.PHONY: install
install: $(STATICLIB) $(DYNAMICLIB)
	mkdir $(INCLOC)
	cp $(INC)/* $(INCLOC)
	cp $(STATICLIB) $(LIBLOC)
	cp $(DYNAMICLIB) $(LIBLOC)


.PHONY: uninstall
uninstall:
	if [ -d "$(INCLOC)" ]; then rm -r $(INCLOC); fi;
	if [ -f "$(LIBLOC)/$(STATICLIB)" ]; then rm $(LIBLOC)/$(STATICLIB); fi;
	if [ -f "$(LIBLOC)/$(DYNAMICLIB)" ]; then rm $(LIBLOC)/$(DYNAMICLIB); fi;


.PHONY: clean
clean:
	if [ -f $(STATICLIB) ]; then rm $(STATICLIB); fi;
	if [ -f $(DYNAMICLIB) ]; then rm $(DYNAMICLIB); fi;
	if [ -f $(HASHTARG) ]; then rm $(HASHTARG); fi;
	if [ -f $(DATACONTTARG) ]; then rm $(DATACONTTARG); fi;
	if [ -f $(DATACONTTESTTARG) ]; then rm $(DATACONTTESTTARG); fi;
	if [ -f $(TREESETNODETARG) ]; then rm $(TREESETNODETARG); fi;
	if [ -f $(TREESETNODETESTTARG) ]; then rm $(TREESETNODETESTTARG); fi;
	if [ -f $(TREESETTARG) ]; then rm $(TREESETTARG); fi;
	if [ -f $(TREESETTESTTARG) ]; then rm $(TREESETTESTTARG); fi;
	if [ -f $(HASHSETTARG) ]; then rm $(HASHSETTARG); fi;
	if [ -f $(HASHSETTESTTARG) ]; then rm $(HASHSETTESTTARG); fi;
	if [ -f $(LISTNODETARG) ]; then rm $(LISTNODETARG); fi;
	if [ -f $(LISTNODETESTTARG) ]; then rm $(LISTNODETESTTARG); fi;
	if [ -f $(TREEMAPNODETARG) ]; then rm $(TREEMAPNODETARG); fi;
	if [ -f $(TREEMAPNODETESTTARG) ]; then rm $(TREEMAPNODETESTTARG); fi;
	if [ -f $(TREEMAPTARG) ]; then rm $(TREEMAPTARG); fi;
	if [ -f $(TREEMAPTESTTARG) ]; then rm $(TREEMAPTESTTARG); fi;
	if [ -f $(HASHMAPTARG) ]; then rm $(HASHMAPTARG); fi;


.PHONY: all
all: run_tests
	@echo "All tests passed."
	@echo "Building static libs..."
	$(MAKE) $(STATICLIB)
	@echo "Done."
	@echo "Building shared libs..."
	$(MAKE) $(DYNAMICLIB)
	@echo "Done."


