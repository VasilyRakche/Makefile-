# In module.mk should be set up:
#	NAME
#	DIR
#	ISLIB

ifdef  DIR
GLOBAL_NAME := $(DIR)/$(NAME)
INC_PATHS += $(INC_PATH)
else
GLOBAL_NAME := $(NAME)
INC_PATHS += inc/$(NAME)
endif


#	Under these names .d files are generated
MODULE_GLOBAL_NAMES += $(GLOBAL_NAME)

#	Taking all source files
#	OBJ files with right directory are set up
#		lib/src/main/main.o to build/lib/main/main.o

$(GLOBAL_NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(GLOBAL_NAME).OBJ := 		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,$($(GLOBAL_NAME).SRC))

#	Library is generated and added to BIN_LIBS
# 	OBJ files are added to BIN_FILES
#
#	BIN_LIBS and BIN_FILES are used for .elf file gen.
ifeq ($(ISLIB),YES)
BIN_LIBS += $(BUILD_DIR)/$(GLOBAL_NAME).a
BIN_FILES += $($(GLOBAL_NAME).OBJ)
else 
BIN_FILES += $($(GLOBAL_NAME).OBJ)
endif

