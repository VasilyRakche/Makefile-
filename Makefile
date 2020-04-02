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

#  $$(patsubst %,$(BUILD_DIR)/%,$$(dir $$<))

# sources_o = $$(subst $$(BUILD_DIR)/,,$$(1))$$(patsubst %.o,src/%.c,$$(2))
# sources_d = $$(subst $$(DEP_DIR)/,,$$(1))$$(patsubst %.d,src/%.c,$$(2))

sources_d = $(subst $(DEP_DIR)/,,$(1))$(patsubst %.d,src/%.c,$(2))
sources_o = $(subst $(BUILD_DIR)/,,$(1))$(patsubst %.o,src/%.c,$(2))


.SECONDEXPANSION:
%.o:  $$(call sources_o,$$(dir $$@),$$(notdir $$@)) $$(dir $$@)
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
$(DEP_DIR)/%.d: $$(call sources_d,$$(dir $$@),$$(notdir $$@)) $$(dir $$@)
	# @echo ".d******* $(call sources_d,$(dir $@),$(notdir $@))"
	bash depend.sh 'dirname $<' \
	$(CFLAGS) $< > $@

$(DEP_DIR)%:
	$(MKDIR) -p $@

.PHONY: clean
clean:
	rm -rf prog $(DEP_DIR) $(BUILD_DIR)