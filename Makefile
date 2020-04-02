.SECONDARY:

MAKEFILE += -r
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
variable = $($(1))
#***********
# PROGRAM compilation
#***********

prog: $(BIN_LIBS)
	@echo "DONE"
	# $(CC) $(CFLAGS) -o $@ $(BIN_LIBS) $(LIBS)

.SECONDEXPANSION:
%.a: $$(warning $$($$(subst .a,.OBJ,$$@))) $$($$(subst .a,.OBJ,$$@))
	@echo ".a****** $^"
	@echo ".a****** $(patsubst %.a,%.OBJ,$@)" 
	$(AR) $(ARFLAGS) $(BUILD_DIR)/$@ $(%.OBJ)


#***********
# GENERATE regular object files
#***********
.SECONDEXPANSION:
%.o: $$(call sources,						\
	$$(subst $$(BUILD_DIR)/,,$$(dir $$@)),	\
	$$(notdir $$@)							\
	) 										\
	$$(dir $$@) 	
	# @echo "$(call sources_o,$(dir $@),$(notdir $@))"
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)%: 
	@echo "build************ $@"
	$(MKDIR) -p $@

#***********
# INCLUDE dependencies
#***********

include $(patsubst \
	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$($(patsubst %,%.OBJ,$(MODULES))))



#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
%.d: $$(call sources,						\
	$$(subst $$(DEP_DIR)/,,$$(dir $$@)),	\
	$$(notdir $$@)							\
	) 										\
	$$(dir $$@)	
	# @echo ".d******* $(call sources,$(subst $(DEP_DIR)/,,$(dir $@)),$(notdir $@))"
	bash depend.sh 'dirname $<' \
	$(CFLAGS) $< > $@

$(DEP_DIR)%:
	$(MKDIR) -p $@


#***********
# PHONY functions
#***********

.PHONY: clean
clean:
	rm -rf prog $(DEP_DIR) $(BUILD_DIR)