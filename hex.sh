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

kingdom=${1}
nw_kingdom=$(cat ${kingdom}/NW)
ne_kingdom=$(cat ${kingdom}/NE)
ww_kingdom=$(cat ${kingdom}/WW)
ee_kingdom=$(cat ${kingdom}/EE)
sw_kingdom=$(cat ${kingdom}/SW)
se_kingdom=$(cat ${kingdom}/SE)

resolve () {
	nw=${nw_kingdom:-UNKNOWN-${kingdom}-NW}
	ne=${ne_kingdom:-UNKNOWN-${kingdom}-NE}
	sw=${sw_kingdom:-UNKNOWN-${kingdom}-SW}
	se=${se_kingdom:-UNKNOWN-${kingdom}-SE}
	case $1 in
		# Northwest
		00)	echo ${nw}/00 ;;
		01)	echo ${nw}/01 ;;
		02)	echo ${nw}/02 ;;
		03)	echo ${nw}/03 ;;
		04)	echo ${nw}/04 ;;

		10)	echo ${nw}/b5 ;;
		11)	echo ${nw}/b6 ;;
		12)	echo ${nw}/b7 ;;
		13)	echo ${nw}/b8 ;;

		20)	echo ${nw}/c5 ;;
		21)	echo ${nw}/c6 ;;

		30)	echo ${nw}/d5 ;;

		# Northeast
		05)	echo ${ne}/a0 ;;
		06)	echo ${ne}/a1 ;;
		07)	echo ${ne}/a2 ;;
		08)	echo ${ne}/a3 ;;
		09)	echo ${ne}/a4 ;;

		17)	echo ${ne}/b2 ;;
		18)	echo ${ne}/b3 ;;
		19)	echo ${ne}/b4 ;;
		1a)	echo ${ne}/b5 ;;

		28)	echo ${ne}/c3 ;;
		29)	echo ${ne}/c4 ;;

		3a)	echo ${ne}/d5 ;;

		# Southwest
		b0)	echo ${sw}/15 ;;

		c0)	echo ${sw}/25 ;;
		c1)	echo ${sw}/26 ;;

		d0)	echo ${sw}/35 ;;
		d1)	echo ${sw}/36 ;;
		d2)	echo ${sw}/37 ;;
		d3)	echo ${sw}/38 ;;

		e0)	echo ${sw}/45 ;;
		e1)	echo ${sw}/46 ;;
		e2)	echo ${sw}/47 ;;
		e3)	echo ${sw}/48 ;;
		e4)	echo ${sw}/49 ;;

		# Southeast
		ba)	echo ${se}/15 ;;

		c8)	echo ${se}/23 ;;
		c9)	echo ${se}/24 ;;
		ca)	echo ${se}/25 ;;

		d7)	echo ${se}/32 ;;
		d8)	echo ${se}/33 ;;
		d9)	echo ${se}/34 ;;
		da)	echo ${se}/35 ;;

		e5)	echo ${se}/40 ;;
		e6)	echo ${se}/41 ;;
		e7)	echo ${se}/42 ;;
		e8)	echo ${se}/43 ;;
		e9)	echo ${se}/44 ;;

		# This hex
		*)	echo ${kingdom}/$1 ;;	
	esac
}

addtile () {
	if [ -f ${kingdom}/$1$2/terrain ]; then
		terrain=$(cat ${kingdom}/$1$2/terrain)
	elif [ -f ${kingdom}/terrain ]; then
		terrain=$(cat ${kingdom}/terrain)
	else
		terrain=unkown
	fi
	printf '<img id="i%c%c" src="%s.png" usemap="#a%c%c">' $1 $2 $terrain $1 $2
	printf '<map name="a%c%c"><area shape="poly" coords="%s" href="%s"></map>' $i $j "${coords}" $(resolve $i$j)
}

header() {
	tr -d '\n' <<-EOH
		<!DOCTYPE html>
		<html><head><meta charset="utf-8"><title>Kingdom Map: $1</title>
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
		printf '#dummy { opacity: 0.1; }'

	for i in ${nw_halves} ${ne_halves} ${ww_halves} ${ee_halves} ${sw_halves} ${se_halves}; do
		printf '#i%s,' $i
	done
		printf '#dummy { opacity: 0.5; }'

	printf '</style></head><body>'
}

footer () {
	tr -d '\n' <<-EOF
		</body></html>
	EOF
}

tiles () {
	odd=1
	for i in 0 1 2 3 4 5 6 7 8 9 a b c d e; do
		printf '<div>'
		for j in 0 1 2 3 4 5 6 7 8 9;  do
			addtile $i $j
		done
		if [ $odd -eq 0 ]; then
			odd=1
			addtile $i $j
		else
			odd=0
		fi
		printf '</div>\n'
	done
}

main() {
	if [ $# -ne 1 ]; then
		echo Usage: $0 kingdom
		exit 1
	fi

	header ${kingdom}
	tiles
	footer
}

main $@
