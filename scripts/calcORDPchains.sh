#!/bin/bash
wget {tpr file path}
wget {trr file path}
tprname={tpr file name} 
trajname={trr file name}
mappingFILE=../../MAPPING/mappingPOPCmacrog.txt
trajgroname=analTMP.gro
sn1outname=OrderParamSN1.dat
sn2outname=OrderParamSN2.dat
echo System | trjconv -f $trajname -s $tprname -o $trajgroname -pbc res -b 100000
for((  j = 3 ;  j <= 16;  j=j+1  ))
do
Cname=$(grep M_G1C"$j"_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1name=$(grep M_G1C"$j"H1_M $mappingFILE | awk '{printf "%5s\n",$2}')
H2name=$(grep M_G1C"$j"H2_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1op=$(awk -v Cname="$Cname" -v Hname="$H1name" -f ../../scripts/gro_OP.awk $trajgroname)
H2op=$(awk -v Cname="$Cname" -v Hname="$H2name" -f ../../scripts/gro_OP.awk $trajgroname)
echo $j $H1op $H2op >> $sn1outname
done
for((  j = 3 ;  j <= 18;  j=j+1  ))
do
Cname=$(grep M_G2C"$j"_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1name=$(grep M_G2C"$j"H1_M $mappingFILE | awk '{printf "%5s\n",$2}')
H2name=$(grep M_G2C"$j"H2_M $mappingFILE | awk '{printf "%5s\n",$2}')
H1op=$(awk -v Cname="$Cname" -v Hname="$H1name" -f ../../scripts/gro_OP.awk $trajgroname)
H2op=$(awk -v Cname="$Cname" -v Hname="$H2name" -f ../../scripts/gro_OP.awk $trajgroname)
echo $j $H1op $H2op >> $sn2outname
done
