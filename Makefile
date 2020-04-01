MODULES := ant
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
include $(OBJ:.o=.d)
#calculate C include
#dependencies
%.d: %.c
	bash depend.sh 'dirname $^' \
	$(CFLAGS) $^ > $@

.PHONY: clean
clean:
	rm -rf $(wildcard ant/*.d) $(wildcard ant/*.o)