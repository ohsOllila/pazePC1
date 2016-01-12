cat ../Data/POPC/densities.dat | awk 'BEGIN{sw=0}{if($3>$2 && sw==0){ b1=$1; sw=1}if($2>$3 && sw==1){b2=$1; sw=0}}END{print b2-b1}'
cat ../Data/PROTONATED/densities.dat | awk 'BEGIN{sw=0}{if($3>$2 && sw==0){ b1=$1; sw=1}if($2>$3 && sw==1){b2=$1; sw=0}}END{print b2-b1}'
cat ../Data/DEPROTONATED/withK/densities.dat | awk 'BEGIN{sw=0}{if($3>$2 && sw==0){ b1=$1; sw=1}if($2>$3 && sw==1){b2=$1; sw=0}}END{print b2-b1}'

