THREAD:=thread

THREAD_LIB_ROOT_DIR:=lib
THREAD_LIB_DIR:=$(THREAD_LIB_ROOT_DIR)/$(THREAD)
THREAD_BIN_DIR:=sample
THREAD_STATIC_LIB:=lib$(THREAD).a

# THREAD_ROOT_DIR is defined later. That's why = is used instead of :=
THREAD_STATIC_LIB_INCLUDE_DIR=$(THREAD_ROOT_DIR)/$(THREAD_LIB_ROOT_DIR)
THREAD_STATIC_LIB_LDLIB=$(THREAD_ROOT_DIR)/$(THREAD_LIB_DIR)/$(THREAD_STATIC_LIB)

# extra flags may be added here or in make invocation. E.g: make EXTRA_CXXFLAGS=-g
EXTRA_CXXFLAGS:=
EXTRA_LDFLAGS:=

ifeq ($(OPTIMIZED), y)
OPTIMIZATION_FLAGS:=-O3 -march=native -flto
else ifeq ($(or $(OPTIMIZED), n), n)
OPTIMIZATION_FLAGS:=-O0 -g
else
$(error Invalid parameter value)
endif

ifeq ($(SANITIZED), y)
ifneq ($(OPTIMIZED), y)
SANITIZE_FLAGS:=-fsanitize=address -fno-omit-frame-pointer
else
$(error Cannot have SANITIZED=y and OPTIMIZED=y)
endif
else ifneq ($(or $(SANITIZED), n), n)
$(error Invalid parameter value)
endif

ifeq ($(WITH_FPIC), n)
FPIC_FLAG:=
else ifeq ($(or $(WITH_FPIC), y), y)
FPIC_FLAG:=-fPIC
else
$(error Invalid parameter value)
endif

ifeq ($(shell uname -s), Darwin)
SHARED_LIB_EXTENSION:=dylib
else
SHARED_LIB_EXTENSION:=so
PTHREAD_FLAG:=-pthread
endif

THREAD_SHARED_LIB:=lib$(THREAD).$(SHARED_LIB_EXTENSION)

THREAD_CXXFLAGS:=$(EXTRA_CXXFLAGS) -std=c++17 -Werror -Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic $(OPTIMIZATION_FLAGS) $(SANITIZE_FLAGS) $(FPIC_FLAG) $(PTHREAD_FLAG)

THREAD_COMMON_LDFLAGS:=$(EXTRA_LDFLAGS) $(OPTIMIZATION_FLAGS) $(SANITIZE_FLAGS) $(PTHREAD_FLAG)
THREAD_SHARED_LDFLAGS:=$(THREAD_COMMON_LDFLAGS) -shared
THREAD_EXECUTABLE_LDFLAGS:=$(THREAD_COMMON_LDFLAGS)
