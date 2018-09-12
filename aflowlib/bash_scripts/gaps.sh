for dir in *ICSD*
do
    (cp command.awk $dir &&
    cd $dir &&
    gawk -f command.awk DOSCAR.static &&
    gawk 'NR==2 {a=$1; next} /0.0000/ {if ($1-a > 0.029 && NR>1) {print $1, $2=a, $3=$1-a} {a=$1}}' data > gap.in
    gawk -v var="${PWD##*/}" 'NR==1 {a=$1; next} {print var,  $1, $2, $3, $4=$2-a} {a=$1}' gap.in > gap.out)
done
