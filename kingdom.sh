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

cat <<-EOH
	<!DOCTYPE html>
	<html><head><meta charset="utf-8"><title>A Region Map</title>
	<link rel="stylesheet" type="text/css" href="map.css">
	<style type="text/css">
	body { margin: 100px; }
	img {
		display: inline;
		width: 60px ! important;
		height: 60px ! important;
		border: none;
		margin: 0;
		padding: 0;
		white-space: nowrap;
	}
	#mainmap {
		top: 100px;
		display: block;
		width: 600px;
		height: 610px;
		border: thin solid red;
	}
	#map > div:nth-child(1) {
		margin-top: -45px;
	}
	#map > div:nth-child(even) {
		/* padding-left: 30px; */
		margin-left: -30px;
	}
	#map > div + div {
		margin-top: -20px;
	}
	map, area {
		display: none;
	}
EOH

for i in ${nw_hexes} ${ne_hexes} ${sw_hexes} ${se_hexes}; do
	printf '#i%s,' $i
done
	printf '#dummy { opacity: 0.2; }\n'

for i in ${nw_halves} ${ne_halves} ${ww_halves} ${ee_halves} ${sw_halves} ${se_halves}; do
	printf '#i%s,' $i
done
	printf '#dummy { opacity: 0.6; }\n'

printf '</style></head><body><div id="mainmap">'

odd=1
for i in 0 1 2 3 4 5 6 7 8 9 a b c d e; do
	printf '<div>'
	for j in 0 1 2 3 4 5 6 7 8 9;  do
		printf '<img id="i%c%c" src="%s" usemap="#a%c%c">' $i $j "grass.png" $i $j
	done
	if [ $odd -eq 0 ]; then
		odd=1
		printf '<img id="i%c%c" src="%s" usemap="#a%c%c">' $i a "grass.png" $i a
	else
		odd=0
	fi
	printf '</div>\n'
done

printf '</div>\n'

coord_nw="0,15"
coord_nn="30,0"
coord_ne="60,15"
coord_se="60,45"
coord_ss="30,60"
coord_sw="0,45"
coords="${coord_nw},${coord_nn},${coord_ne},${coord_se},${coord_ss},${coord_sw}"

for i in ${nw_hexes}; do
	printf '<map name="a%s"><area shape="poly" coords="%s" href="../NW"></map>\n' $i "${coords}"
done

for i in ${nw_halves}; do
	printf '<map name="a%s">' $i
	printf '<area shape="poly" coords="%s" href="../NW">' "${coord_sw},${coord_nw},${coord_nn},${coord_ne}"
	printf '<area shape="poly" coords="%s" href="%s">' "${coord_sw},${coord_ne},${coord_se},${coord_ss}" $i
	printf '</map>\n'
done

for i in ${ne_hexes}; do
	printf '<map name="a%s"><area shape="poly" coords="%s" href="../NE"></map>\n' $i "${coords}"
done

for i in ${ne_halves}; do
	printf '<map name="a%s">' $i
	printf '<area shape="poly" coords="%s" href="../NE">' "${coord_nw},${coord_nn},${coord_ne},${coord_se}"
	printf '<area shape="poly" coords="%s" href="%s">' "${coord_nw},${coord_se},${coord_ss},${coord_sw}" $i
	printf '</map>\n'
done

for i in ${ww_halves}; do
	printf '<map name="a%s">' $i
	printf '<area shape="poly" coords="%s" href="../WW">' "${coord_nn},${coord_nw},${coord_sw},${coord_ss}"
	printf '<area shape="poly" coords="%s" href="%s">' "${coord_nn},${coord_ne},${coord_se},${coord_ss}" $i
	printf '</map>\n'
done

for i in ${ee_halves}; do
	printf '<map name="a%s">' $i
	printf '<area shape="poly" coords="%s" href="../EE">' "${coord_nn},${coord_ne},${coord_se},${coord_ss}"
	printf '<area shape="poly" coords="%s" href="%s">' "${coord_nn},${coord_nw},${coord_sw},${coord_ss}" $i
	printf '</map>\n'
done

for i in ${sw_hexes}; do
	printf '<map name="a%s"><area shape="poly" coords="%s" href="../SW"></map>\n' $i "${coords}"
done

for i in ${sw_halves}; do
	printf '<map name="a%s">' $i
	printf '<area shape="poly" coords="%s" href="../SW">' "${coord_nw},${coord_se},${coord_ss},${coord_sw}"
	printf '<area shape="poly" coords="%s" href="%s">' "${coord_nw},${coord_nn},${coord_ne},${coord_se}" $i
	printf '</map>\n'
done

for i in ${se_hexes}; do
	printf '<map name="a%s"><area shape="poly" coords="%s" href="../SE"></map>\n' $i "${coords}"
done

for i in ${se_halves}; do
	printf '<map name="a%s">' $i
	printf '<area shape="poly" coords="%s" href="../SE">' "${coord_sw},${coord_ne},${coord_se},${coord_ss}"
	printf '<area shape="poly" coords="%s" href="%s">' "${coord_sw},${coord_nw},${coord_nn},${coord_ne}" $i
	printf '</map>\n'
done

cat <<-EOF
	<map name="nw">
		<area shape="poly" coords="${coords}" href="../${nw}">
	</map>
	</body></html>
EOF
