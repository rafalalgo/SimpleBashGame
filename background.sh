#!/bin/bash

###################################################
#     wstepny zarys planszy
###################################################
tput civis
tput bold
tput setaf 4
K=80;
M=16;
W=25;
touch plansza_we.in
rm -r plansza_we.in
touch plansza_we.in
touch plansza_wy.in
rm -r plansza_wy.in
touch plansza_wy.in

for((i=1;i<=$M;i++))
do
	echo -n "@$i@ " >> plansza_we.in
	for((j=1;j<=$K;j++))
	do
		echo -n "%$j%=" >> plansza_we.in
	done
	echo -e "\n" >> plansza_we.in	
done

for((i=$[M+1];i<=$W;i++))
do
	echo -n "@$i@ " >> plansza_we.in
	for((j=1;j<=$K;j++))
	do
		echo -n "%$j%#" >> plansza_we.in
	done
	echo -e "\n" >> plansza_we.in	
done

clear
sed 's/[0-9 @%\n]//g' plansza_we.in > plansza_wy.in
I=1;
for WERS in $(cat plansza_wy.in)
do
	if [ $I -gt 16 ];
	then
		tput setaf 2
	fi
	
	echo "$WERS"
	I=$[I+1];
done

t=1;

###################################################
#     pnie drzew
###################################################

for((h=1;h<=3;h++))
do
	for((i=12;i<=17;i++))
	do
		for((j=$[h*20+9];j<=$[h*20+11];j++))
		do
			tput setaf 0
			tput cup $i $j
			echo -n "|"
		done
	done
done

###################################################
#     korony drzew
###################################################

for((h=1;h<=3;h++))
do
	for((i=11;i>=4;i--))
	do
		for((j=$[h*20+6];j<=$[h*20+14];j++))
		do
			tput setaf 2
			tput cup $i $j
			echo -n "$"
		done
	done
done

###################################################
#     sloneczko
###################################################

for((i=3;i<=5;i++))
do
	for((j=$[6-i+1];j<=$[6+i-1];j++))
	do
		tput setaf 3
		tput cup $[i-2] $j
		echo -n "o"
	done
done

for((i=8;i>=6;i--))
do
	for((j=$[i-4];j<=$[i-1];j++))
	do
		tput setaf 3
		tput cup $[i-2] $j
		echo -n "o"
	done
done

for((i=4;i<=6;i++))
do
	for((j=$[7+3-i];j<=$[14-i];j++))
	do
		tput setaf 3
		tput cup $i $j
		echo -n "o"
	done
done

###################################################
#     tu cos sie musi zaczac dziac
###################################################

while [ $t == 1 ];
do
	tput setaf 3
	tput cup 2 3
	echo "o"
done

#Rafał Byczek