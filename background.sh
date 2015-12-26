#!/bin/bash

###################################################
#     ekran przed gra
###################################################
tput civis
tput bold
clear
tput setaf 4
echo -e "\n\n"
echo "       OOO       OOO      OOOOO       OOOOOOO     OOOOOOO     OOOOO"
echo "       OOOO     OOOO     OOOOOOO     OOOOOOOOO    OOOOOOO    OOOOOOO"
echo "       OOOOO   OOOOO    OOO   OOO    OOO    OOO     OOO     OOO   OOO"
echo "       OOOOOO OOOOOO   OOO     OOO   OOO    OOO     OOO    OOO     OOO"
echo "       OOO OOOOO OOO   OOOOOOOOOOO   OOOOOOOOOO     OOO    OOO     OOO"
echo "       OOO  OOO  OOO   OOOOOOOOOOO   OOOOOOOO       OOO    OOO     OOO "
echo "       OOO   O   OOO   OOO     OOO   OOO  OOO       OOO     OOO   OOO"
echo "       OOO       OOO   OOO     OOO   OOO   OOO    OOOOOOO    OOOOOOO"
echo "       OOO       OOO   OOO     OOO   OOO    OOO   OOOOOOO     OOOOO"
echo -e "\n\n\n\n\n"
echo "              Nacisnij dowolny klawisz zeby rozpoczac rozgrywke."
read zmienna

###################################################
#     wstepny zarys planszy
###################################################
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
		echo -n "%$j%^" >> plansza_we.in
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
	for((i=10;i<=14;i++))
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
	for((j=$[h*20+7];j<=$[h*20+13];j++))
	do
		tput setaf 2
		tput cup 4 $j
		echo -n "$"
	done
	
	for((j=$[h*20+7];j<=$[h*20+13];j++))
	do
		tput setaf 2
		tput cup 9 $j
		echo -n "$"
	done
	
	for((i=8;i>=5;i--))
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

for((i=3;i<=4;i++))
do
	for((j=$[4-i+1];j<$[4+i-1];j++))
	do
		tput setaf 3
		tput cup $[i - 2] $j
		echo -n "O"
	done
done
i=3;
for((j=$[4-i+1];j<$[4+i-1];j++))
do
	tput setaf 3
	tput cup $i $j
	echo -n "O"
done

###################################################
#     tu cos sie musi zaczac dziac
###################################################

while [ $t == 1 ];
do
	tput setaf 3
	tput cup 2 3
	echo "O"
done

#Rafał Byczek