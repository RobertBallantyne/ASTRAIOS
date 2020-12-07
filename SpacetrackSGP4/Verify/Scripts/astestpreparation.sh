#!/bin/bash -f

for filey in $(find ../../ -name *.sh)
do
	echo $filey
	sed -i 's/\r$//g' $filey
	chmod +rx $filey
done

for filey in $(find ../../ -name *.out)
do
	echo $filey
	sed -i 's/\r$//g' $filey
done


for filey in $(find ../../ -name *.ini)
do
	echo $filey
	sed -i 's/\r$//g' $filey
done

for filey in $(find ../../ -name Verdict_Linux*)
do
	echo $filey
	chmod +rx $filey
done

for filey in $(find ../../ -name C*Linux*)
do
	echo $filey
	#sed -i 's/\r$//g' $filey
	chmod +rx $filey
done

for filey in $(find ../../ -name *.INP)
do
	echo $filey
	namer=`echo $filey | cut -d "." -f1-2`
	namer2="$namer.inp"
	echo $namer2
	mv $filey $namer2
done

for filey in $(find ../../ -name *.inp)
do
	sed -i 's/\\/\//g' $filey
done



