NAME := stm32boot
DIR := lib
SRC_DIR:= $(DIR)/src/$(NAME)


BIN_LIBS += $(DIR)/$(NAME).a
INC_PATHS += $(DIR)/inc/$(NAME)

$(DIR)/$(NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(DIR)/$(NAME).OBJ := 		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst /src,,$($(DIR)/$(NAME).SRC)))
	# $(patsubst %.c,%.o,$($(DIR)/$(NAME).SRC))

# SRC += ant/src/main.c

# $(warning A top-level warning $(SRC))
# $(warning In module.mk)
# $(warning ****$($(DIR)/$(NAME).SRC))
# $(warning ****$($(DIR)/$(NAME).OBJ))


# $(warning in $(NAME))
# $(warning $(DIR)/$(NAME).OBJ) 
# $(warning $($(DIR)/$(NAME).OBJ)) 
# $(warning $(DIR)/$(NAME).a) 
# $(warning $(BIN_LIBS)) 
# $(warning $(INC_PATHS)) 
