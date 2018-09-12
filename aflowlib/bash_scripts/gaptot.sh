FILES="*ICSD*/gap.out"
OUTPUT="gaptot.in"

for dir in $FILES
do
	cat $dir >> $OUTPUT       
done

gawk -f gaptot.awk gaptot.in > gaptot.out
