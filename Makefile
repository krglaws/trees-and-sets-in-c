
CC := gcc
CFLAGS := -Iinclude -fPIC
TESTFLAGS := -Iinclude

SRC := src
INC := include
SBIN := bin

TEST := tests
TBIN := testbin

INCLOC := /usr/include/kylestructs
LIBLOC := /usr/lib

default: all


# compile sources

DATACONTDEPS := $(SRC)/ks_datacont.c 
DATACONTTARG := $(SBIN)/ks_datacont.o

$(DATACONTTARG): $(DATACONTDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


LISTNODEDEPS := $(SRC)/ks_listnode.c
LISTNODETARG := $(SBIN)/ks_listnode.o

$(LISTNODETARG): $(LISTNODEDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


LISTDEPS := $(SRC)/ks_list.c
LISTTARG := $(SBIN)/ks_list.o

$(LISTTARG): $(LISTDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


TREESETNODEDEPS := $(SRC)/ks_treesetnode.c
TREESETNODETARG := $(SBIN)/ks_treesetnode.o

$(TREESETNODETARG): $(TREESETNODEDEPS) 
	$(CC) -c $< -o $@ $(CFLAGS)


TREESETDEPS := $(SRC)/ks_treeset.c 
TREESETTARG := $(SBIN)/ks_treeset.o

$(TREESETTARG): $(TREESETDEPS) 
	$(CC) -c $< -o $@ $(CFLAGS)


HASHSETDEPS := $(SRC)/ks_hashset.c 
HASHSETTARG := $(SBIN)/ks_hashset.o

$(HASHSETTARG): $(HASHSETDEPS) 
	$(CC) -c $< -o $@ $(CFLAGS)


TREEMAPNODEDEPS := $(SRC)/ks_treemapnode.c 
TREEMAPNODETARG := $(SBIN)/ks_treemapnode.o

$(TREEMAPNODETARG): $(TREEMAPNODEDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


TREEMAPDEPS := $(SRC)/ks_treemap.c 
TREEMAPTARG := $(SBIN)/ks_treemap.o

$(TREEMAPTARG): $(TREEMAPDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)


HASHMAPDEPS := $(SRC)/ks_hashmap.c 
HASHMAPTARG := $(SBIN)/ks_hashmap.o

$(HASHMAPTARG): $(HASHMAPDEPS)
	$(CC) -c $< -o $@ $(CFLAGS)



# compile tests

DATACONTTESTDEPS := $(DATACONTDEPS)
DATACONTTESTTARG := $(TBIN)/datacont_tests.out

$(DATACONTTESTTARG): $(TEST)/datacont_tests.c $(DATACONTTESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


LISTNODETESTDEPS := $(DATACONTTESTDEPS) $(LISTNODEDEPS) 
LISTNODETESTTARG := $(TBIN)/listnode_tests.out

$(LISTNODETESTTARG): $(TEST)/listnode_tests.c $(LISTNODETESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


LISTTESTDEPS := $(LISTNODETESTDEPS) $(LISTDEPS)
LISTTESTTARG := $(TBIN)/list_tests.out

$(LISTTESTTARG): $(TEST)/list_tests.c $(LISTTESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


TREESETNODETESTDEPS := $(LISTNODETESTDEPS) $(TREESETNODEDEPS)
TREESETNODETESTTARG := $(TBIN)/treesetnode_tests.out

$(TREESETNODETESTTARG): $(TEST)/treesetnode_tests.c $(TREESETNODETESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


TREESETTESTDEPS := $(TREESETNODETESTDEPS) $(TREESETDEPS)
TREESETTESTTARG := $(TBIN)/treeset_tests.out

$(TREESETTESTTARG): $(TEST)/treeset_tests.c $(TREESETTESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


HASHSETTESTDEPS := $(TREESETTESTDEPS) $(LISTTESTDEPS) $(HASHSETDEPS)
HASHSETTESTTARG := $(TBIN)/hashset_tests.out

$(HASHSETTESTTARG): $(TEST)/hashset_tests.c $(HASHSETTESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


TREEMAPNODETESTDEPS := $(LISTNODETESTDEPS) $(TREEMAPNODEDEPS)
TREEMAPNODETESTTARG := $(TBIN)/treemapnode_tests.out

$(TREEMAPNODETESTTARG): $(TEST)/treemapnode_tests.c $(TREEMAPNODETESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


TREEMAPTESTDEPS := $(TREEMAPNODETESTDEPS) $(LISTTESTDEPS) $(TREEMAPDEPS)
TREEMAPTESTTARG := $(TBIN)/treemap_tests.out

$(TREEMAPTESTTARG): $(TEST)/treemap_tests.c $(TREEMAPTESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


HASHMAPTESTDEPS += $(TREEMAPTESTDEPS) $(HASHMAPDEPS)
HASHMAPTESTTARG := $(TBIN)/hashmap_tests.out

$(HASHMAPTESTTARG): $(TEST)/hashmap_tests.c $(HASHMAPTESTDEPS)
	$(CC) -g $^ -o $@ $(TESTFLAGS)


.PHONY: run_tests
run_tests: tests
	./runtests.sh


.PHONY: tests
tests: $(DATACONTTESTTARG) $(LISTNODETESTTARG) $(LISTTESTTARG) $(TREESETNODETESTTARG)\
  $(TREESETTESTTARG) $(HASHSETTESTTARG) $(TREEMAPNODETESTTARG) $(TREEMAPTESTTARG) $(HASHMAPTESTTARG)
	@echo Finished building tests.


STATICLIB := libkylestructs.a
$(STATICLIB): $(DATACONTTARG) $(LISTNODETARG) $(LISTTARG) $(TREESETNODETARG)\
	$(TREESETTARG) $(HASHSETTARG) $(TREEMAPNODETARG) $(TREEMAPTARG) $(HASHMAPTARG)
	ar rcs $(STATICLIB)\
		$(DATACONTTARG)\
		$(LISTNODETARG)\
		$(LISTTARG)\
		$(TREESETNODETARG)\
		$(TREESETTARG)\
		$(HASHSETTARG)\
		$(TREEMAPNODETARG)\
		$(TREEMAPTARG)\
		$(HASHMAPTARG)


DYNAMICLIB := libkylestructs.so
$(DYNAMICLIB): $(DATACONTTARG) $(LISTNODETARG) $(LISTTARG) $(TREESETNODETARG)\
		$(TREESETTARG) $(HASHSETTARG) $(LISTNODETARG) $(TREEMAPNODETARG) $(TREEMAPTARG) $(HASHMAPTARG)
	gcc -shared -o $(DYNAMICLIB)\
		$(DATACONTTARG)\
		$(LISTNODETARG)\
		$(LISTTARG)\
		$(TREESETNODETARG)\
		$(TREESETTARG)\
		$(HASHSETTARG)\
		$(TREEMAPNODETARG)\
		$(TREEMAPTARG)\
		$(HASHMAPTARG)


.PHONY: install
install: $(STATICLIB) $(DYNAMICLIB)
	mkdir $(INCLOC)
	cp $(INC)/* $(INCLOC)
	mv $(INCLOC)/kylestructs.h $(INCLOC)/.. 
	cp $(STATICLIB) $(LIBLOC)
	cp $(DYNAMICLIB) $(LIBLOC)


.PHONY: uninstall
uninstall:
	if [ -d $(INCLOC) ]; then rm -r $(INCLOC); fi;
	if [ -f $(INCLOC)/../kylestructs.h ]; then rm -r $(INCLOC)/../kylestructs.h ]; fi;
	if [ -f $(LIBLOC)/$(STATICLIB) ]; then rm $(LIBLOC)/$(STATICLIB); fi;
	if [ -f $(LIBLOC)/$(DYNAMICLIB) ]; then rm $(LIBLOC)/$(DYNAMICLIB); fi;


.PHONY: clean
clean:
	if [ -f $(STATICLIB) ]; then rm $(STATICLIB); fi;
	if [ -f $(DYNAMICLIB) ]; then rm $(DYNAMICLIB); fi;
	if [ -f $(DATACONTTARG) ]; then rm $(DATACONTTARG); fi;
	if [ -f $(DATACONTTESTTARG) ]; then rm $(DATACONTTESTTARG); fi;
	if [ -f $(LISTNODETARG) ]; then rm $(LISTNODETARG); fi;
	if [ -f $(LISTNODETESTTARG) ]; then rm $(LISTNODETESTTARG); fi;
	if [ -f $(LISTTARG) ]; then rm $(LISTTARG); fi;
	if [ -f $(LISTTESTTARG) ]; then rm $(LISTTESTTARG); fi;
	if [ -f $(TREESETNODETARG) ]; then rm $(TREESETNODETARG); fi;
	if [ -f $(TREESETNODETESTTARG) ]; then rm $(TREESETNODETESTTARG); fi;
	if [ -f $(TREESETTARG) ]; then rm $(TREESETTARG); fi;
	if [ -f $(TREESETTESTTARG) ]; then rm $(TREESETTESTTARG); fi;
	if [ -f $(HASHSETTARG) ]; then rm $(HASHSETTARG); fi;
	if [ -f $(HASHSETTESTTARG) ]; then rm $(HASHSETTESTTARG); fi;
	if [ -f $(TREEMAPNODETARG) ]; then rm $(TREEMAPNODETARG); fi;
	if [ -f $(TREEMAPNODETESTTARG) ]; then rm $(TREEMAPNODETESTTARG); fi;
	if [ -f $(TREEMAPTARG) ]; then rm $(TREEMAPTARG); fi;
	if [ -f $(TREEMAPTESTTARG) ]; then rm $(TREEMAPTESTTARG); fi;
	if [ -f $(HASHMAPTARG) ]; then rm $(HASHMAPTARG); fi;
	if [ -f $(HASHMAPTESTTARG) ]; then rm $(HASHMAPTESTTARG); fi;


.PHONY: all
all: run_tests
	@echo "All tests passed."
	@echo "Building static libs..."
	$(MAKE) $(STATICLIB)
	@echo "Done."
	@echo "Building shared libs..."
	$(MAKE) $(DYNAMICLIB)
	@echo "Done."


