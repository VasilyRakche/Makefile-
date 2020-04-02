NAME := antee
DIR := ant
SRC_DIR:= $(DIR)/src/$(NAME)
INC_DIR := $(DIR)/inc/$(NAME)

BIN_LIBS += $(DIR)/$(NAME).a

INC_PATHS += $(INC_DIR)

$(DIR)/$(NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(DIR)/$(NAME).OBJ := 		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst /src,,$($(DIR)/$(NAME).SRC)))
	# $(patsubst %.c,%.o,$($(DIR)/$(NAME).SRC))
	
SRC += ant/src/main.c

# $(warning A top-level warning $(SRC))
# $(warning In module.mk)
# $(warning ****$($(DIR)/$(NAME).SRC))
# $(warning ****$($(DIR)/$(NAME).OBJ))
