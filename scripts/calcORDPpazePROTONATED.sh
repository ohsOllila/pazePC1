#!/bin/bash
tmpDIRname=OPcalcPROTpazetmp
tprname=/wrk/ollilas1/OXIDIZEDdata/PROTONATED/pzpcRUN2.tpr
tprname402=/wrk/ollilas1/OXIDIZEDdata/PROTONATED/402.tpr
trajname=/wrk/ollilas1/OXIDIZEDdata/PROTONATED/pzpcRUN1-3.xtc
mappingFILE=../../../HGmodel/NMRlipids/NmrLipidsCholXray/MAPPING/mappingPAZEPCberger.txt
trajgroname=runPROT.gro
HGGLYoutname=../../Data/PROTONATED/OrderParamGHGLYpaze.dat
sn1outname=../../Data/PROTONATED/OrderParamSN1paze.dat
sn2outname=../../Data/PROTONATED/OrderParamSN2paze.dat
groOPpath=../gro_OP.awk
hdbFILE=../ffgmx2.hdb
starttime=100000
mkdir $tmpDIRname
cd $tmpDIRname
cp $hdbFILE ./ffgmx2.hdb
echo System | trjconv -f $trajname -s $tprname -o trajINBOX.xtc -pbc res -b $starttime
echo PZPC | /home/ollilas1/gromacs/gromacs402/bin/protonate -f trajINBOX.xtc -s $tprname402 -o runPROT.gro
#CALCULATE HEADGROUP AND GLYCEROL ORDER PARAMETERS
rm $HGGLYoutname
awk -v Cname="   C5" -v Hname="  H51" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="   C5" -v Hname="  H52" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="   C6" -v Hname="  H61" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="   C6" -v Hname="  H62" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C12" -v Hname=" H121" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C12" -v Hname=" H122" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C13" -v Hname=" H131" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C27" -v Hname=" H271" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C27" -v Hname=" H272" -f $groOPpath runPROT.gro >> $HGGLYoutname
#CALCULATE SN-1 ORDER PARAMETERS
rm $sn1outname
for((  j = 3 ;  j <= 16;  j=j+1  ))
do
Cname=$(grep M_G1C"$j"_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1name=$(grep M_G1C"$j"H1_M $mappingFILE | awk '{printf "%5s\n",$2}')
H2name=$(grep M_G1C"$j"H2_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1op=$(awk -v Cname="$Cname" -v Hname="$H1name" -f $groOPpath $trajgroname)
H2op=$(awk -v Cname="$Cname" -v Hname="$H2name" -f $groOPpath $trajgroname)
echo $j $H1op $H2op >> $sn1outname
done
#CALCULATE SN-2 ORDER PARAMETERS
rm $sn2outname
for((  j = 3 ;  j <= 9;  j=j+1  ))
do
Cname=$(grep M_G2C"$j"_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1name=$(grep M_G2C"$j"H1_M $mappingFILE | awk '{printf "%5s\n",$2}')
H2name=$(grep M_G2C"$j"H2_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1op=$(awk -v Cname="$Cname" -v Hname="$H1name" -f $groOPpath $trajgroname)
H2op=$(awk -v Cname="$Cname" -v Hname="$H2name" -f $groOPpath $trajgroname)
echo $j $H1op $H2op >> $sn2outname
done
cd ..
#rm -r $tmpDIRname
