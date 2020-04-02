DEP_DIR := .deps
MODULES := ant
MKDIR := mkdir
#look for include files in
#each of the modules
CFLAGS += $(patsubst %,-I%,\
	$(MODULES))
#extra libraries if required
LIBS :=
#each module will add to this
SRC :=
#include the description for
#each module
include $(patsubst %,\
	%/module.mk,$(MODULES))

#determine the object files
OBJ :=                    \
	$(patsubst %.c,%.o,     \
	$(filter %.c,$(SRC))) 

#link the program
prog: $(OBJ)
	$(CC) -o $@ $(OBJ) $(LIBS)
#include the C include
#dependencies
include $(patsubst \
	%.o,$(DEP_DIR)/%.d,$(OBJ))
#calculate C include
#dependencies
.SECONDEXPANSION:
$(DEP_DIR)/%.d: %.c $$(dir $$@)
	bash depend.sh 'dirname $<' \
	$(CFLAGS) $< > $@

$(DEP_DIR)%:
	$(MKDIR) -p $@

.PHONY: clean
clean:
	rm -rf $(wildcard ant/*.d) $(wildcard ant/*.o) prog $(DEP_DIR)