#!/bin/bash
# Save all the configs will be changed by tune.sh
# into recover.sh, which can be used to recover
# the old configs

infile=tune.sh
outfile=recover.sh

echo "#!/bin/bash" > $outfile

for i in $(cat $infile | awk -F'>' '{print $2}' | grep -v '^$')
do
	echo -n "echo " >> $outfile
	echo -n $(cat $i) >> $outfile
	echo -n " > " >> $outfile
	echo $i >> $outfile
done

chmod +x $outfile
