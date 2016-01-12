#!/bin/bash
mappingFILE=../../../HGmodel/NMRlipids/NmrLipidsCholXray/MAPPING/mappingPOPCberger.txt
tmpDIRname=DENScalcTMPdeprotonated
tprname=/wrk/ollilas1/OXIDIZEDdata/DEPROTONATED/withK/pzpcRUN2.tpr
trajname=/wrk/ollilas1/OXIDIZEDdata/DEPROTONATED/withK/pzpcRUN2.trr
outname=../../Data/DEPROTONATED/withK/densities.dat
starttime=0
endtime=59000
mkdir $tmpDIRname
cd $tmpDIRname
LIPIDname=$(grep M_POPC_M $mappingFILE | awk '{printf "%5s\n",$2}')
LIPIDindexNR=$(echo q | make_ndx -f $tprname | grep $LIPIDname | awk '{if(NR==1)print $1}')
SOLindexNR=$(echo q | make_ndx -f $tprname | grep SOL | awk '{if(NR==1)print $1}')
rm chainCARBONS1.dat
rm chainCARBONS2.dat
echo -n a >> chainCARBONS1.dat
echo -n a >> chainCARBONS2.dat
for((  j = 3 ;  j <= 16;  j=j+1  ))
do
grep M_G1C"$j"_M $mappingFILE | awk '{printf "%5s ",$2}' >> chainCARBONS1.dat
done
echo "" >> chainCARBONS1.dat
for((  j = 3 ;  j <= 18;  j=j+1  ))
do
grep M_G2C"$j"_M $mappingFILE | awk '{printf "%5s ",$2}' >> chainCARBONS2.dat
done
echo "" >> chainCARBONS2.dat
echo q >> chainCARBONS1.dat
echo q >> chainCARBONS2.dat
echo 'keep 6
q
' | make_ndx -f $tprname
cat chainCARBONS1.dat | make_ndx -f $tprname -n index.ndx -o index.ndx
cat chainCARBONS2.dat | make_ndx -f $tprname -n index.ndx -o index.ndx 
echo '1|2
q
' | make_ndx -f $tprname -n index.ndx -o index.ndx
echo $LIPIDindexNR System | trjconv -f $trajname -s $tprname -fit progressive -o ANALtraj.xtc -b $starttime -e $endtime
#Ztrans=$(tail -n 1 $groFILE | awk '{print $3/2}')
#Ztrans=-1
#echo System | trjconv -f FITtraj.xtc -s $tprname -trans 0 0 $Ztrans -o ANALtraj.xtc
echo 0 3 | g_density -f ANALtraj.xtc -s $tprname -dens number -o densNC.xvg -xvg none -sl 100 -ng 2 -n index.ndx
echo System | trjconv -f ANALtraj.xtc -s $tprname -o INBOXtraj.xtc -pbc mol
echo $LIPIDindexNR | g_traj -f INBOXtraj.xtc -s $tprname -ox com.xvg -com -xvg none
Zcom=$(cat com.xvg | awk '{sumZ=sumZ+$4; sum=sum+1}END{print sumZ/sum}')
cat densNC.xvg | awk -v Zcom=$Zcom '{print $1-Zcom" "$2" "$3" "$4}' > $outname
cd ..
#rm -r $tmpDIRname
