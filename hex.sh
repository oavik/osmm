#!/bin/sh
nw_hexes="00 01 02 03 04 10 11 12 13 20 21 30"
nw_halves="14 22 31"
ne_hexes="05 06 07 08 09 17 18 19 1a 28 29 2a 3a"
ne_halves="16 27 39"
ww_halves="50 70 90"
ee_halves="5a 7a 9a"
sw_hexes="b0 c0 c1 d0 d1 d2 d3 e0 e1 e2 e3 e4"
sw_halves="b1 c2 d4"
se_hexes="ba c8 c9 ca d7 d8 d9 da e5 e6 e7 e8 e9"
se_halves="b9 c7 d6"

coord_nw="0,15"
coord_nn="30,0"
coord_ne="60,15"
coord_se="60,45"
coord_ss="30,60"
coord_sw="0,45"
coords="${coord_nw},${coord_nn},${coord_ne},${coord_se},${coord_ss},${coord_sw}"

terrain=${1:-grass.png}

resolve () {
	case $1 in
		# Northwest
		00)	echo NW-00 ;;
		01)	echo NW-01 ;;
		02)	echo NW-02 ;;
		03)	echo NW-03 ;;
		04)	echo NW-04 ;;

		10)	echo NW-b5 ;;
		11)	echo NW-b6 ;;
		12)	echo NW-b7 ;;
		13)	echo NW-b8 ;;

		20)	echo NW-c5 ;;
		21)	echo NW-c6 ;;

		30)	echo NW-d5 ;;

		# Northeast
		05)	echo NE-a0 ;;
		06)	echo NE-a1 ;;
		07)	echo NE-a2 ;;
		08)	echo NE-a3 ;;
		09)	echo NE-a4 ;;

		17)	echo NE-b2 ;;
		18)	echo NE-b3 ;;
		19)	echo NE-b4 ;;
		1a)	echo NE-b5 ;;

		28)	echo NE-c3 ;;
		29)	echo NE-c4 ;;

		3a)	echo NE-d5 ;;

		*)	echo $1 ;;	
	esac
}

cat <<-EOH
	<!DOCTYPE html>
	<html><head><meta charset="utf-8"><title>A Region Map</title>
	<link rel="stylesheet" type="text/css" href="map.css">
	<style type="text/css">
	img {
		display: inline;
		width: 60px ! important;
		height: 60px ! important;
		border: none;
		margin: 0;
		padding: 0;
		white-space: nowrap;
	}
	div:nth-child(1) {
		margin-top: -45px;
	}
	div:nth-child(even) {
		/* padding-left: 30px; */
		margin-left: -30px;
	}
	div + div {
		margin-top: -20px;
	}
	map, area {
		display: none;
	}
EOH

for i in ${nw_hexes} ${ne_hexes} ${sw_hexes} ${se_hexes}; do
	printf '#i%s,' $i
done
	printf '#dummy { opacity: 0.1; }\n'

for i in ${nw_halves} ${ne_halves} ${ww_halves} ${ee_halves} ${sw_halves} ${se_halves}; do
	printf '#i%s,' $i
done
	printf '#dummy { opacity: 0.5; }\n'

printf '</style></head><body>'

odd=1
for i in 0 1 2 3 4 5 6 7 8 9 a b c d e; do
	printf '<div>'
	for j in 0 1 2 3 4 5 6 7 8 9;  do
		printf '<img id="i%c%c" src="%s" usemap="#a%c%c">' $i $j $terrain $i $j
		printf '<map name="a%c%c"><area shape="poly" coords="%s" href="%s"></map>' $i $j "${coords}" $(resolve $i$j)
	done
	if [ $odd -eq 0 ]; then
		odd=1
		printf '<img id="i%c%c" src="%s" usemap="#a%c%c">' $i a $terrain $i a
		printf '<map name="a%c%c"><area shape="poly" coords="%s" href="%s"></map>' $i a "${coords}" $(resolve ${i}a)
	else
		odd=0
	fi
	printf '</div>\n'
done

cat <<-EOF
	<map name="nw">
		<area shape="poly" coords="${coords}" href="../${nw}">
	</map>
	</body></html>
EOF
