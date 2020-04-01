#****************************************************
# File          : depend.sh
# Author        : Peter  Miller
# Date          : 10.03.2008
# Description   : Miller,P.A. (1998),Recursive Make 
#                  Considered Harmful,AUUGN Journal 
#                  of AUUG Inc., 19(1), pp. 14-25
# Source        : http://aegis.sourceforge.net/auug97.pdf
#****************************************************

#!/bin/bash
DIR=$($1)
shift 1

#DEPFLAGS="-MT $@ -MD -MP"
DEPFLAGS="-MM -MG $@"
case $DIR in
"" | ".")
OUT=$(arm-none-eabi-gcc $DEPFLAGS)
echo $OUT |
sed -e "s@ˆ\(.*\)\.o:@\1.d \1.o:@"
;;
*)
OUT=$(arm-none-eabi-gcc $DEPFLAGS)
echo $OUT |
sed -e "s@ˆ\(.*\)\.o:@$DIR/\1.d \
$DIR/\1.o:@"
;;
esac
