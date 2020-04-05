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


MODULES := lib . 

#***********
# VARIABLE definitions
#***********

#extra libraries if required
LIBS :=


#***********
# INCLUDE module descriptions
#***********
define module_handler
include $(1)/module.mk
include handler.mk
endef

$(foreach MODULE,$(MODULES),$(eval $(call module_handler,$(MODULE))) )
#***********
# CHECK
#***********

# $(warning HEY)

#***********
# UPDATES
#***********

CFLAGS +=$(patsubst %,-I%,\
	$(INC_PATHS))

BIN_LIBS:=$(addprefix $(BUILD_DIR)/,$(BIN_LIBS))
# #determine the object files

# OBJ :=                    	\
# 	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
# 	$(subst /src,,$(SRC)))	


#***********
# PROGRAM compilation
#***********
DEPEND:= $(BUILD_DIR)/main.a $(BUILD_DIR)/lib/stm32boot.a
prog: $(DEPEND)
	@echo "DONE"
	# $(CC) $(CFLAGS) -o $@ $(BIN_LIBS) $(LIBS)

.SECONDEXPANSION:
$(BUILD_DIR)/%.a: $$(warning $$($$(addsuffix .OBJ,%))) $$($$(addsuffix .OBJ,%))
	#%.a
	$(AR) $(ARFLAGS) $@ $^


#***********
# GENERATE regular object files
#***********

join_with_src = $(dir $(1))src/$(notdir $(1))/$(2).c
to_c =$(call join_with_src,\
$(patsubst %/$(notdir $(1)),%,$(1)),$(notdir $(1)))

.SECONDEXPANSION:
$(BUILD_DIR)/%.o: $$(warning $$(call to_c,%)) $$(call to_c,%)
	#%.o		
	$(MKDIR) -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

#***********
# INCLUDE dependencies
#***********


define include_d_from_o =
	include $(patsubst $(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,\
	$(subst /src,,$($(addsuffix .OBJ,$(1)))))
endef
$(foreach MODULE,$(GLOBAL_NAMES),$(eval $(call include_d_from_o,$(MODULE))) )


DEP_LIB := $(patsubst \
	$(BUILD_DIR)/%.a,$(DEP_DIR)/%.d,$(BIN_LIBS))
include $(DEP_LIB)


#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
$(DEP_DIR)/%.d: $$(call to_c,%)	
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