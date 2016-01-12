tmpdir=APMcalcTMPpopc
tprname=/media/be85b54b-6796-4273-9ee1-0914d3a40746/nonionics/POPCnewDATA/popc407.tpr
trajname=/media/be85b54b-6796-4273-9ee1-0914d3a40746/nonionics/POPCnewDATA/popc1-8.xtc
outfile=../../Data/POPC/areaPERmolecule.dat
starttime=30000
endtime=268000
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


