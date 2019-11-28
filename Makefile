include common.mk

INSTALL_TOP?=/usr/local
INSTALL_INC:=$(INSTALL_TOP)/include/$(PROJECT)
INSTALL_LIB:=$(INSTALL_TOP)/lib

.PHONY: all static static_release shared shared_release sample install_static install uninstall clean

# Any of the following make rules can be executed with the `-j` option (`make -j`) for parallel compilation 

all:
	cd $(PROJECT_LIB_DIR) && $(MAKE) $@

static:
	cd $(PROJECT_LIB_DIR) && $(MAKE) $@

static_release: clean
	cd $(PROJECT_LIB_DIR) && $(MAKE) static OPTIMIZED=y WITH_FPIC=n

shared:
	cd $(PROJECT_LIB_DIR) && $(MAKE) $@

shared_release:
	cd $(PROJECT_LIB_DIR) && $(MAKE) shared OPTIMIZED=y

sample: static
	cd $(PROJECT_BIN_DIR) && $(MAKE) all

install_static:
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(PROJECT_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(PROJECT_LIB_DIR)/$(PROJECT_STATIC_LIB) $(INSTALL_LIB)

install:
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(PROJECT_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(PROJECT_LIB_DIR)/$(PROJECT_STATIC_LIB) $(PROJECT_LIB_DIR)/$(PROJECT_SHARED_LIB) $(INSTALL_LIB)

uninstall:
	$(RM) -R $(INSTALL_INC)
	$(RM) $(INSTALL_LIB)/$(PROJECT_STATIC_LIB) $(INSTALL_LIB)/$(PROJECT_SHARED_LIB)

clean:
	cd $(PROJECT_LIB_DIR) && $(MAKE) $@
	cd $(PROJECT_BIN_DIR) && $(MAKE) $@
