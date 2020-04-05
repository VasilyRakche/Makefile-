.SECONDARY:

MAKEFLAGS += -r
DEP_DIR := .deps
MKDIR := mkdir
BUILD_DIR ?= build
PROJECT := stm32f10x

# compiler options 
CC := arm-none-eabi-gcc
AR := arm-none-eabi-ar
LD := arm-none-eabi-gcc

#***********
# VARIABLE definitions
#***********

# includes 
INC_PATHS :=	\
	ld 

BIN_LIBS :=
# compiler flags
CFLAGS :=	\
	-mcpu=cortex-m3 \
 	-mthumb -Wall	\
	-g	\
	-O0

LDFLAGS := 	\
	-Wl,	\
	--gc-sections,	\
	-Map=$@.map,	\
	-cref,	\
	--orphan-handling=warn,	\
	-u,Reset_Handler\
	-T stm32.ld 

ARFLAGS := rcs


MODULES := lib/main lib/stm32boot 

#***********
# VARIABLE definitions
#***********

#extra libraries if required
LIBS :=


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


#***********
# PROGRAM compilation
#***********

prog: $(patsubst %,$(BUILD_DIR)/%.a,$(MODULES))
	@echo "DONE"
	# $(CC) $(CFLAGS) -o $@ $(BIN_LIBS) $(LIBS)

.SECONDEXPANSION:
$(BUILD_DIR)/%.a: $$($$(addsuffix .OBJ,%))
	#%.a
	$(AR) $(ARFLAGS) $@ $^


#***********
# GENERATE regular object files
#***********

var2 = $(dir $(1))src/$(notdir $(1))/$(2).c
var =$(call var2,\
$(patsubst %/$(notdir $(1)),%,$(1)),$(notdir $(1)))

.SECONDEXPANSION:
$(BUILD_DIR)/%.o: $$(call var,%)
	#%.o		
	$(MKDIR) -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

#***********
# INCLUDE dependencies
#***********


define include_d_prog =
	include $(patsubst \
	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$(subst /src,,$($(patsubst %,%.OBJ,$(MODULE)))))
endef
$(foreach MODULE,$(MODULES),$(eval $(call include_d_prog,$(MODULE))) )


DEP_LIB := $(patsubst \
	$(BUILD_DIR)/%.a,$(DEP_DIR)/%.d,$(addprefix $(BUILD_DIR)/,$(BIN_LIBS)))
include $(DEP_LIB)


#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
$(DEP_DIR)/%.d: $$(call var,%)	
	#%.d		
	$(MKDIR) -p $(dir $@)	
	bash depend.sh 'dirname $@' \
	'dirname $(patsubst $(DEP_DIR)%,$(BUILD_DIR)%,$@)'   \
	$(CFLAGS) $< > $@


.SECONDEXPANSION:
$(DEP_LIB): $$(subst .d,.a,$$(subst $$(DEP_DIR),$$(BUILD_DIR),$$@))
	#DEP_LIB
	$(MKDIR) -p $(dir $@)
	echo "$@ $<: $($(subst $(BUILD_DIR)/,,$(basename $<)).OBJ)" > $@


#***********
# PHONY functions
#***********

.PHONY: clean
clean:
	rm -rf prog $(DEP_DIR) $(BUILD_DIR)