#!/bin/bash 
# mostly from http://arxiv.org/pdf/1403.2642.pdf						
SERVER=http://aflowlib.duke.edu 					# server name in AFLOW

# mkdir /Users/douglas/Desktop/Big_Data/AFLOW_scripts/6Spec

WORKPATH=/Users/douglas/Desktop/Big_Data/AFLOW_scripts/6Spec					# where set up calculations in ARCHER

# see http://aflowlib.duke.edu/AFLOWDATA/ICSD_WEB/
CGROUP=(BCC BCT CUB FCC HEX MCL MCLC ORC ORCC ORCF ORCI RHL TET TRI)
i=1
# loop around crystallographic groups (ICSD_WEB/BCC, ICSD_WEB_BCT, etc.)
for g in ${CGROUP[@]}
do
	PROJECT=ICSD_WEB/$g 							# project name AFLOW
	URL=$SERVER/AFLOWDATA/$PROJECT/ 				# project-layer AFLOW
	ENTRIES=$(wget -q -O - ${URL}?aflowlib_entries) # get all entries in this project-layer

	#http://stackoverflow.com/questions/10586153/split-string-into-an-array-in-bash
	IFS=',' read -r -a array_entries <<< "$ENTRIES"; 	# put entries in array
	for key in ${!array_entries[@]}
	do
		# http://stackoverflow.com/questions/229551/string-contains-in-bash
		# http://stackoverflow.com/questions/17028143/regular-expression-in-bash-script
		# if [[ (${array_entries[key]} == *"Ta"[0-9]*) && (${array_entries[key]} == *"O"[0-9]*) ]]
		# then
			COMPOUND=$URL${array_entries[key]}/				# calculation-layer

			DFT=$(wget -q -O - ${COMPOUND}?dft_type)
			LDAU=$(wget -q -O - ${COMPOUND}?ldau_TLUJ)
			CODE=$(wget -q -O - ${COMPOUND}?code)
			NSPECIES=$(wget -q -O - ${COMPOUND}?nspecies)
			EGAP=$(wget -q -O - ${COMPOUND}?Egap)
			
			# http://stackoverflow.com/questions/8654051/how-to-compare-two-floating-point-numbers-in-a-bash-script
			# a=`echo "$EGAP >= 0.1" | bc`
			# b=`echo "$EGAP < 3.0" | bc`
			
			# if [[ ($EGAP -ge 0.1) && ($EGAP -lt 3.0) && ($NSPECIES == 2) ]]
			if [[ ($NSPECIES == 6) && ($EGAP < 3)]]
			then
				echo "   >> compound # "$i" = "${array_entries[key]};
				i=$(($i + 1))
				echo "		  Egap = "$EGAP
				FILES=$(wget -q -O - ${COMPOUND}?files)				# get all files in calculation-layer

               			mkdir $WORKPATH/${array_entries[key]}
				cd $WORKPATH/${array_entries[key]}

				IFS=',' read -r -a array_files <<< "$FILES"			# put file entries in array
				for file in ${!array_files[@]}
				do
					if [[ (${array_files[file]} == *"DOSCAR"*) ]]
					then
						echo "		  "${array_files[file]} 						# print keyword
						wget ${COMPOUND}/${array_files[file]}
						if [[ ${array_files[file]} == *"bz2" ]]
						then
							bzip2 -d ${array_files[file]}
						fi
					fi
				done
				# cat $PSEUDOPATH/Mo/POTCAR $PSEUDOPATH/O/POTCAR > POTCAR
				# cp KPOINTS.static KPOINTS
				# cp CONTCAR*vasp POSCAR
				# cp /home/e05/e05/padilha/submit/job-mck .

				echo " "
			# fi
		fi
	done	
done
