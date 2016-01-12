tmpdir=APMcalcTMPdeprotonated
tprname=/wrk/ollilas1/OXIDIZEDdata/DEPROTONATED/withK/pzpcRUN2.tpr
trajname=/wrk/ollilas1/OXIDIZEDdata/DEPROTONATED/withK/pzpcRUN2.trr
outfile=../../Data/DEPROTONATED/withK/areaPERmolecule.dat
starttime=0
endtime=59000
mkdir $tmpdir
cd $tmpdir
rm AperMblocks.dat 
for((  j = $starttime ;  j <= $endtime;  j=j+2000  ))
do
i=$(($j+1000))
rm box.xvg
echo 0 | g_traj -f $trajname -s $tprname -ob box.xvg -b $j -e $i -xvg none
cat box.xvg | awk '{Asum=Asum+$2*$3*2/128; sum=sum+1}END{print Asum/sum}' >> AperMblocks.dat 
done
AperMav=$(cat AperMblocks.dat | awk '{sumA=sumA+$1;sum=sum+1}END{print sumA/sum}')
cat AperMblocks.dat | awk -v AperMav=$AperMav '{sumSD=sumSD+($1-AperMav)*($1-AperMav);sum=sum+1}END{print AperMav" "sqrt(sumSD/sum)/sqrt(sum)}' > $outfile
cd ..


