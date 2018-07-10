# Descobrir a energia do nível de Fermi 
NR==6 {fermi=$4; print fermi > "data"}

# Subtrair a energia do nível de Fermi dos valores iniciais
{correction=$1-fermi}

# Encontrar a vizinhança onde a energia é zero
# NR>=7 && NR<=5006 {if ($1==fermi) refline=NR; print refline, " "}

# NR==2 {a=$1; next} {if ($1 - a > 0.1) {print $1,  $1-a} {a=$1}} (usar fora)


# Selecionar parte do arquivo que possua densidade de estados igual a zero

NR==6 {max=$3+6}

  {
   if ($2==$3 && /0.0000E/ && NR>=7 && NR<=max) 
	print correction,  $2,  $3 >> "data"; 
   else if ($2!=$3 && NR>=7 && NR<=max && /0.0000E/ && length($4)==0)
	print correction,  $2 >> "data"
   }

		
