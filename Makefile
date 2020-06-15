THREAD_ROOT_DIR:=.

include common.mk

INSTALL_TOP:=/usr/local
INSTALL_INC:=$(INSTALL_TOP)/include/$(PROJECT)
INSTALL_LIB:=$(INSTALL_TOP)/lib

.PHONY: all static static_release shared shared_release sample install_static install uninstall clean

# Any of the following make rules can be executed with the `-j` option (`make -j`) for parallel compilation 

all:
	cd $(THREAD_LIB_DIR) && $(MAKE) $@

static:
	cd $(THREAD_LIB_DIR) && $(MAKE) $@

static_release: clean
	cd $(THREAD_LIB_DIR) && $(MAKE) static OPTIMIZED=y WITH_FPIC=n

shared:
	cd $(THREAD_LIB_DIR) && $(MAKE) $@

shared_release:
	cd $(THREAD_LIB_DIR) && $(MAKE) shared OPTIMIZED=y

sample: static
	cd $(THREAD_BIN_DIR) && $(MAKE) all

install_static:
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(THREAD_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(THREAD_LIB_DIR)/$(THREAD_STATIC_LIB) $(INSTALL_LIB)

install:
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(THREAD_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(THREAD_LIB_DIR)/$(THREAD_STATIC_LIB) $(THREAD_LIB_DIR)/$(THREAD_SHARED_LIB) $(INSTALL_LIB)

uninstall:
	$(RM) -R $(INSTALL_INC)
	$(RM) $(INSTALL_LIB)/$(THREAD_STATIC_LIB) $(INSTALL_LIB)/$(THREAD_SHARED_LIB)

clean:
	cd $(THREAD_LIB_DIR) && $(MAKE) $@
	cd $(THREAD_BIN_DIR) && $(MAKE) $@
