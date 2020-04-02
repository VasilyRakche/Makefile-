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
#***********
# PROGRAM compilation
#***********

prog: $(BIN_LIBS)
	@echo "DONE"
	# $(CC) $(CFLAGS) -o $@ $(BIN_LIBS) $(LIBS)

.SECONDEXPANSION:
%.a: $$($$(subst .a,.OBJ,$$@)) 
	# $$(warning $$($$(subst .a,.OBJ,$$@)))
	# @echo ".a****** $^"
	# @echo ".a****** $(patsubst %.a,%.OBJ,$@)" 
	$(AR) $(ARFLAGS) $(BUILD_DIR)/$@ $(addprefix $(BUILD_DIR)/,$(subst /src,,$^))


#***********
# GENERATE regular object files
#***********
.SECONDEXPANSION:
%.o:%.c 										\
	$$(BUILD_DIR)/$$(subst /src,,$$(dir $$@))	
	# @echo ".o******$(BUILD_DIR)/$(subst /src,,$@)"
	$(CC) $(CFLAGS) -c $< -o $(BUILD_DIR)/$(subst /src,,$@)

$(BUILD_DIR)%: 
	# @echo "build************ $@"
	$(MKDIR) -p $@

#***********
# INCLUDE dependencies
#***********

include $(patsubst \
	%.o,$(DEP_DIR)/%.d,$(subst /src,,$($(patsubst %,%.OBJ,$(MODULES)))))



#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
%.d:$$(call variable,		\
	$$(subst $$(DEP_DIR)/,,$$@),				\
	$$(notdir $$@)							\
	)									\
	$$(dir $$@)	
	# @echo ".d******* $(call sources,$(subst $(DEP_DIR)/,,$(dir $@)),$(notdir $@))"
	bash depend.sh 'dirname $@' \
	'dirname $(patsubst $(DEP_DIR)%,$(BUILD_DIR)%,$@)'   \
	$(CFLAGS) $< > $@

$(DEP_DIR)%:
	$(MKDIR) -p $@


#***********
# PHONY functions
#***********

.PHONY: clean
clean:
	rm -rf prog $(wildcard $(SRC_DIR)/*.o) $(DEP_DIR) $(BUILD_DIR)