NAME := stm32boot
DIR := lib

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

MODULE_NAMES += $(GLOBAL_NAME)

BIN_LIBS += $(GLOBAL_NAME).a


$(GLOBAL_NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(GLOBAL_NAME).OBJ := 		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst $(SRC_PREFIX),,$($(GLOBAL_NAME).SRC)))


# SRC += ant/src/main.c

# $(warning A top-level warning $(SRC))
$(warning In module.mk)
$(warning $($(GLOBAL_NAME).OBJ))

# $(warning ****$($(DIR)/$(NAME).OBJ))


# $(warning in $(NAME))
# $(warning $(DIR)/$(NAME).OBJ) 
# $(warning $($(DIR)/$(NAME).OBJ)) 
# $(warning $(DIR)/$(NAME).a) 
# $(warning $(BIN_LIBS)) 
# $(warning $(INC_PATHS)) 
