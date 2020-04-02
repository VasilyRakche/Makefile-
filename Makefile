MAKEFILE += -r
DEP_DIR := .deps
MODULES := ant
MKDIR := mkdir
BUILD_DIR ?= build

# includes **
INC_PATHS := \
	$(BUILD_DIR)

#look for include files in
#each of the modules
CFLAGS += $(patsubst %,-I%,\
	$(MODULES))
#extra libraries if required
LIBS :=
#each module will add to this
SRC :=
#include the description for
#each module
include $(patsubst %,\
	%/module.mk,$(MODULES))

CFLAGS +=$(patsubst %,-I%,\
	$(INC_PATHS))

#determine the object files
OBJ :=                    	\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst /src,,$(SRC)))	
# $(subst /src,,$(SRC)))

#link the program
prog: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LIBS)

sources = $(1)src/$(basename $(2)).c

.SECONDEXPANSION:
%.o:$$(call sources,	\
	$$(subst $$(BUILD_DIR)/,,$$(dir $$@)),	\
	$$(notdir $$@)) 	\
	$$(dir $$@) 	
	# @echo "$(call sources_o,$(dir $@),$(notdir $@))"
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)%: 
	@echo "build************ $@"
	$(MKDIR) -p $@

#include the C include
#dependencies
include $(patsubst \
	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$(OBJ))
	
#calculate C include
#dependencies
.SECONDEXPANSION:
%.d: $$(call sources,	\
	$$(subst $$(DEP_DIR)/,,$$(dir $$@)),	\
	$$(notdir $$@)) 	\
	$$(dir $$@)	
	# @echo ".d******* $(call sources,$(subst $(DEP_DIR)/,,$(dir $@)),$(notdir $@))"
	bash depend.sh 'dirname $<' \
	$(CFLAGS) $< > $@

$(DEP_DIR)%:
	$(MKDIR) -p $@

.PHONY: clean
clean:
	rm -rf prog $(DEP_DIR) $(BUILD_DIR)