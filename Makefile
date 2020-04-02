.SECONDARY:

MAKEFLAGS += -r
DEP_DIR := .deps
MKDIR := mkdir
BUILD_DIR ?= build
PROJECT := main

AR := ar 


MODULES := ant/antee
#***********
# VARIABLE definitions
#***********

# includes 
INC_PATHS := 
#c compiler flags
CFLAGS :=

ARFLAGS := rcs
#extra libraries if required
LIBS :=
#each module will add to this
SRC :=

#***********
# INCLUDE module descriptions
#***********
include $(patsubst %,\
	%/module.mk,$(MODULES))


#***********
# CHECK
#***********

# $(warning HEY)

#***********
# UPDATES
#***********

CFLAGS +=$(patsubst %,-I%,\
	$(INC_PATHS))

# #determine the object files
# OBJ :=                    	\
# 	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
# 	$(subst /src,,$(SRC)))	

sources = $(1)src/$(basename $(2)).c
variable = 	$(dir $(subst $(addprefix /,$(2)),,$(1)))src/$(notdir $(subst $(addprefix /,$(2)),,$(1)))/$(basename $(2)).c
		# $(warning variable and $(2) $(1) and $(subst $(addprefix /,$(2)),,$(1)) )
objects = $(patsubst $(BUILD_DIR)/%.a,%.OBJ,$(1))
#***********
# PROGRAM compilation
#***********

prog: $(addprefix $(BUILD_DIR)/,$(BIN_LIBS))
	@echo "DONE"
	# $(CC) $(CFLAGS) -o $@ $(BIN_LIBS) $(LIBS)

.SECONDEXPANSION:
%.a: $$($$(call objects,$$@))
	# @echo ".a****** $^"
	# @echo ".a****** $(patsubst %.a,%.OBJ,$@)" 
	$(AR) $(ARFLAGS) $@ $^


#***********
# GENERATE regular object files
#***********
.SECONDEXPANSION:
%.o:$$(call variable,							\
	$$(subst $$(BUILD_DIR)/,,$$@),				\
	$$(notdir $$@)							\
	)									\
	$$(dir $$@)		
	# @echo ".o******$(BUILD_DIR)/$(subst /src,,$@)"
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)%: 
	# @echo "build************ $@"
	$(MKDIR) -p $@

#***********
# INCLUDE dependencies
#***********

include $(patsubst \
	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$(subst /src,,$($(patsubst %,%.OBJ,$(MODULES)))))

DEP_LIB := $(patsubst \
	$(BUILD_DIR)/%.a,$(DEP_DIR)/%.d,$(addprefix $(BUILD_DIR)/,$(BIN_LIBS)))
include $(DEP_LIB)

#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
%.d:$$(call variable,		\
	$$(subst $$(DEP_DIR)/,,$$@),				\
	$$(notdir $$@)							\
	)									\
	$$(dir $$@)	
	@echo ".d******* $^"
	bash depend.sh 'dirname $@' \
	'dirname $(patsubst $(DEP_DIR)%,$(BUILD_DIR)%,$@)'   \
	$(CFLAGS) $< > $@


.SECONDEXPANSION:
$(DEP_LIB): $$(subst .d,.a,$$(subst $$(DEP_DIR),$$(BUILD_DIR),$$@)) $$(dir $$@)
	$(warning dp**$($(subst $(BUILD_DIR)/,,$(basename $<)).OBJ))
	echo "$@ $<: $($(subst $(BUILD_DIR)/,,$(basename $<)).OBJ)" > $@

$(DEP_DIR)%:
	$(MKDIR) -p $@


#***********
# PHONY functions
#***********

.PHONY: clean
clean:
	rm -rf prog $(wildcard $(SRC_DIR)/*.o) $(DEP_DIR) $(BUILD_DIR)