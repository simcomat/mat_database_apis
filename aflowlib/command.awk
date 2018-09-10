# Getting the Fermi energy  
NR==6 {fermi=$4; print fermi > "data"}

# Fermi energy shift
{correction=$1-fermi}

# Selecting only the parts of the file where the DOS is zero

NR==6 {max=$3+6}

  {
   if ($2==$3 && /0.0000E/ && NR>=7 && NR<=max) 
	print correction,  $2,  $3 >> "data"; 
   else if ($2!=$3 && NR>=7 && NR<=max && /0.0000E/ && length($4)==0)
	print correction,  $2 >> "data"
   }

		
