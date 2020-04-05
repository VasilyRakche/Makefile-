# In module.mk are defined:
#	NAME
#	DIR
#	ISLIB


ifdef  DIR
SRC_PREFIX := /src
SRC_DIR:= $(DIR)/src/$(NAME)
GLOBAL_NAME := $(DIR)/$(NAME)
INC_PATHS += $(DIR)/inc/$(NAME)
else
SRC_PREFIX := src/
SRC_DIR:= src/$(NAME)
GLOBAL_NAME := $(NAME)
INC_PATHS += inc/$(NAME)
endif

MODULE_GLOBAL_NAMES += $(GLOBAL_NAME)

ifeq ($(ISLIB),YES)
$(warning ISLIB $(NAME))
BIN_LIBS += $(GLOBAL_NAME).a
endif


$(GLOBAL_NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(GLOBAL_NAME).OBJ := 		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst $(SRC_PREFIX),,$($(GLOBAL_NAME).SRC)))