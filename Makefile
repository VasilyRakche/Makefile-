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

sources = $(1)src/$(basename $(2)).c
variable = 	$(dir $(subst $(addprefix /,$(2)),,$(1)))src/$(notdir $(subst $(addprefix /,$(2)),,$(1)))/$(basename $(2)).c
		# $(warning variable and $(2) $(1) and $(subst $(addprefix /,$(2)),,$(1)) )
objects = $(patsubst $(BUILD_DIR)/%.a,%.OBJ,$(1))
#***********
# PROGRAM compilation
#***********

prog: $(patsubst %,$(BUILD_DIR)/%.a,$(MODULES))
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
	)									
	# $$(dir $$@)		
	$(MKDIR) -p $(dir $@)
	# @echo ".o******$(BUILD_DIR)/$(subst /src,,$@)"
	$(CC) $(CFLAGS) -c $< -o $@

# $(BUILD_DIR)%: 
# 	# @echo "build************ $@"
# 	$(MKDIR) -p $@

#***********
# INCLUDE dependencies
#***********


define include_d_prog =
	include $(patsubst \
	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$(subst /src,,$($(patsubst %,%.OBJ,$(MODULE)))))
endef

$(foreach MODULE,$(MODULES),$(eval $(call include_d_prog,$(MODULE))) )

# include $(patsubst \
# 	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$(subst /src,,$($(patsubst %,%.OBJ,$(MODULES)))))
# $(warning First include)
# $(warning $(patsubst %,%.OBJ,$(MODULES)) )
# $(warning $(foreach OBJ,$(patsubst %,%.OBJ,$(MODULES)),$($(OBJ))) ) 
# $(warning $(subst /src,,$($(patsubst %,%.OBJ,$(MODULES))) ) )
# $(warning $(patsubst \
# 	$(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,$(subst /src,,$($(patsubst %,%.OBJ,$(MODULES))))))


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
	)									
	# $$(dir $$@)
	$(MKDIR) -p $(dir $@)	
	@echo ".d******* $^"
	bash depend.sh 'dirname $@' \
	'dirname $(patsubst $(DEP_DIR)%,$(BUILD_DIR)%,$@)'   \
	$(CFLAGS) $< > $@


.SECONDEXPANSION:
$(DEP_LIB): $$(subst .d,.a,$$(subst $$(DEP_DIR),$$(BUILD_DIR),$$@))
	$(MKDIR) -p $(dir $@)
	$(warning dp**$($(subst $(BUILD_DIR)/,,$(basename $<)).OBJ))
	echo "$@ $<: $($(subst $(BUILD_DIR)/,,$(basename $<)).OBJ)" > $@

# $(DEP_DIR)%:
# 	$(MKDIR) -p $@


#***********
# PHONY functions
#***********

.PHONY: clean
clean:
	rm -rf prog $(wildcard $(SRC_DIR)/*.o) $(DEP_DIR) $(BUILD_DIR)