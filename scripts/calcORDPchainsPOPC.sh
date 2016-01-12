#!/bin/bash
tmpDIRname=OPcalcPOPCtmp
trajname=/media/be85b54b-6796-4273-9ee1-0914d3a40746/nonionics/POPCnewDATA/popc1-8.xtc
tprname402=/media/be85b54b-6796-4273-9ee1-0914d3a40746/nonionics/POPCnewDATA/popc407.tpr
tprname=/media/be85b54b-6796-4273-9ee1-0914d3a40746/nonionics/POPCnewDATA/popc407.tpr
mappingFILE=../../../HGmodel/NMRlipids/NmrLipidsCholXray/MAPPING/mappingPOPCberger.txt
trajgroname=runPROT.gro
HGGLYoutname=../../Data/POPC/OrderParamGHGLY.dat
sn1outname=../../Data/POPC/OrderParamSN1.dat
sn2outname=../../Data/POPC/OrderParamSN2.dat
groOPpath=../gro_OP.awk
hdbFILE=/wrk/ollilas1/HGmodel/NMRlipids/lipid_ionINTERACTION/scratch/ffgmx2berger.hdb
starttime=30000
endtime=270000
mkdir $tmpDIRname
cd $tmpDIRname
cp $hdbFILE ./ffgmx2.hdb
echo System | trjconv -f $trajname -s $tprname -o trajINBOX.xtc -pbc res -b $starttime -e $endtime
echo PLA | /home/ollilas1/gromacs/gromacs402/bin/protonate -f trajINBOX.xtc -s $tprname402 -o runPROT.gro
#CALCULATE HEADGROUP AND GLYCEROL ORDER PARAMETERS
rm $HGGLYoutname
awk -v Cname="   C5" -v Hname="  H51" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="   C5" -v Hname="  H52" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="   C6" -v Hname="  H61" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="   C6" -v Hname="  H62" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C12" -v Hname=" H121" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C12" -v Hname=" H122" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C13" -v Hname=" H131" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C32" -v Hname=" H321" -f $groOPpath runPROT.gro >> $HGGLYoutname
awk -v Cname="  C32" -v Hname=" H322" -f $groOPpath runPROT.gro >> $HGGLYoutname
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
for((  j = 3 ;  j <= 18;  j=j+1  ))
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
