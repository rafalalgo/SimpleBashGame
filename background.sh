#!/bin/bash

###################################################
#     postac kucajaca
###################################################
rysuj_postac_kucajaca()
{
	# GŁOWA
	tput setab 7
	tput setaf 7
	tput cup 13 9; echo "#"
	tput setab 3
	tput setaf 3
	tput cup 13 10; echo " "
	tput setab 7
	tput setaf 7
	tput cup 13 11; echo "#"
	tput setab 3
	tput setaf 3
	tput cup 14 8; echo " "
	tput setab 9
	tput setaf 9
	tput cup 14 9; echo "*"
	tput setab 3
	tput setaf 3
	tput cup 14 10; echo " "
	tput setab 9
	tput setaf 9
	tput cup 14 11; echo "*"
	tput setab 3
	tput setaf 3
	tput cup 14 12; echo " "
	tput cup 15 9; echo "[-]"
	tput setab 1
	tput setaf 1
	tput cup 16 9; echo ">-<"
	#KLATKA PIERSIOWA
	tput setab 9
	tput setaf 9
	tput cup 17 7;  echo "   "
	tput setab 7
	tput setaf 7
	tput cup 17 10;  echo " "
	tput setab 9
	tput setaf 9
	tput cup 17 11;  echo "  "
	tput cup 18 6;  echo "   "
	tput setab 3
	tput setaf 3
	tput cup 18 9;  echo "="
	tput setab 7
	tput setaf 7
	tput cup 18 10;  echo " "
	tput setab 9
	tput setaf 9
	tput cup 18 11;  echo "   "
	tput setab 3
	tput setaf 3
	tput cup 18 14;  echo "="
	tput setab 9
	tput setaf 9
	tput cup 19 8;  echo "  "
	tput setab 7
	tput setaf 7
	tput cup 19 10;  echo " "
	tput setab 9
	tput setaf 9
	tput cup 19 11;  echo "  "
	tput setab 3
	tput setab 7
	tput setaf 7
	tput cup 20 7;  echo " "
	tput setab 9
	tput setaf 9
	tput cup 20 8;  echo "     "
	tput setab 7
	tput setaf 7
	tput cup 21 7;  echo " "
	tput setab 9
	tput setaf 9
	tput cup 21 8;  echo "  "
	tput setab 7
	tput setaf 7
	tput cup 21 11;  echo "   "
}

###################################################
#     postac stojaca
###################################################
rysuj_postac_stojaca()
{
# GŁOWA
tput setab 7
tput setaf 7
tput cup 11 9; echo "#"
tput setab 3
tput setaf 3
tput cup 11 10; echo " "
tput setab 7
tput setaf 7
tput cup 11 11; echo "#"
tput setab 3
tput setaf 3
tput cup 12 8; echo " "
tput setab 9
tput setaf 9
tput cup 12 9; echo "*"
tput setab 3
tput setaf 3
tput cup 12 10; echo " "
tput setab 9
tput setaf 9
tput cup 12 11; echo "*"
tput setab 3
tput setaf 3
tput cup 12 12; echo " "
tput cup 13 9; echo "[-]"
tput setab 1
tput setaf 1
tput cup 14 9; echo ">-<"
#KLATKA PIERSIOWA
tput setab 9
tput setaf 9
tput cup 15 7;  echo "   "
tput setab 7
tput setaf 7
tput cup 15 10;  echo " "
tput setab 9
tput setaf 9
tput cup 15 11;  echo "   "
tput cup 16 6;  echo "    "
tput setab 7
tput setaf 7
tput cup 16 10;  echo " "
tput setab 9
tput setaf 9
tput cup 16 11;  echo "    "
tput cup 17 6;  echo "    "
tput setab 7
tput setaf 7
tput cup 17 10;  echo " "
tput setab 9
tput setaf 9
tput cup 17 11;  echo "    "
tput setab 3
tput setaf 3
tput cup 18 6; echo "||"
tput setab 9
tput setaf 9
tput cup 18 8;  echo "     "
tput setab 3
tput setaf 3
tput cup 18 13; echo "||"
#SPODNIE
tput setab 9
tput setaf 9
tput cup 19 8;  echo -n "  "
tput setab 2
tput setaf 2
echo -n "^"
tput setab 9
tput setaf 9
echo -n "  " 
tput cup 20 8;  echo -n "  "
tput setab 2
tput setaf 2
echo -n "^"
tput setab 9
tput setaf 9
echo -n "  " 
tput setab 7
tput setaf 7
tput cup 21 7;  echo -n "   "
tput setab 2
tput setaf 2
echo -n "^"
tput setab 7
tput setaf 7
echo -n "   "
}

wyczysc_dol_planszy()
{
for((i=14;i<=21;i++))
do
	for((j=6;j<=14;j++))
	do
		tput setab 2
		tput setaf 2
		tput cup $i $j
		echo -n "^"
	done
done

for((i=10;i<=13;i++))
do
	for((j=6;j<=14;j++))
	do
		tput setab 4
		tput setaf 4
		tput cup $i $j
		echo -n "s"
	done
done
}

printf_ekran()
{
###################################################
#     ekran przed gra
###################################################

tput civis
tput bold
clear
tput setaf 4
echo -e "\n\n"
echo "       OOO       OOO      OOOOO       OOOOOOOO    OOOOOOO     OOOOO"
echo "       OOOO     OOOO     OOOOOOO     OOOOOOOOOO   OOOOOOO    OOOOOOO"
echo "       OOOOO   OOOOO    OOO   OOO    OOO    OOO     OOO     OOO   OOO"
echo "       OOOOOO OOOOOO   OOO     OOO   OOO    OOO     OOO    OOO     OOO"
echo "       OOO OOOOO OOO   OOOOOOOOOOO   OOOOOOOOOO     OOO    OOO     OOO"
echo "       OOO  OOO  OOO   OOOOOOOOOOO   OOOOOOOO       OOO    OOO     OOO "
echo "       OOO   O   OOO   OOO     OOO   OOO  OOO       OOO     OOO   OOO"
echo "       OOO       OOO   OOO     OOO   OOO   OOO    OOOOOOO    OOOOOOO"
echo "       OOO       OOO   OOO     OOO   OOO    OOO   OOOOOOO     OOOOO"
echo -e "\n\n"
tput setaf 3

echo "      			   JKM SPECIAL EDITION"
tput setaf 4
echo -e "\n\n"
echo "              Nacisnij dowolny klawisz zeby rozpoczac rozgrywke."
read zmienna

###################################################
#     wstepny zarys planszy
###################################################
tput setab 4
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
echo -n "@$i@" >> plansza_we.in
for((j=1;j<=$K;j++))
do
	echo -ne "%$j%s" >> plansza_we.in
done
echo -e "\n" >> plansza_we.in	
done

for((i=$[M+1];i<=$W;i++))
do
echo -n "@$i@" >> plansza_we.in
for((j=1;j<=$K;j++))
do
	echo -n "%$j%^" >> plansza_we.in
done
echo -e "\n" >> plansza_we.in	
done

clear
sed 's/[0-9@%\n]//g' plansza_we.in > plansza_wy.in
I=1;
for WERS in $(cat plansza_wy.in)
do
if [ $I -gt 16 ];
then
	tput setab 2
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
		tput setab 0
		tput setaf 0
		tput cup $i $j
		echo -n " "
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
	tput setab 2
	tput setaf 2
	tput cup 4 $j
	echo -n "*"
done

for((j=$[h*20+7];j<=$[h*20+13];j++))
do
	tput setab 2
	tput setaf 2
	tput cup 9 $j
	echo -n "*"
done

for((i=8;i>=5;i--))
do
	for((j=$[h*20+6];j<=$[h*20+14];j++))
	do
		tput setab 2
		tput setaf 2
		tput cup $i $j
		echo -n "*"
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
	tput setab 3
	tput setaf 3
	tput cup $[i - 2] $[j+1]
	echo -n "o"
done
done

for((j=$[4-3+1];j<$[4+3-1];j++))
do
tput setab 3
tput setaf 3
tput cup 3 $[j+1]
echo -n "o"
done
}
###################################################
#     tu cos sie musi zaczac dziac
###################################################

printf_ekran

stan=1
min=11
max=21

rysuj_postac_stojaca

while [ $t -eq 1 ] || [ $t -eq 2 ] ;
do
	if [ $t -eq 1 ] && [ $stan -eq 2 ];
	then
		wyczysc_dol_planszy
		rysuj_postac_stojaca
		min=11
		max=21
		stan=1
	fi
	
	if [ $t -eq 2 ] && [ $stan -eq 1 ];
	then
		wyczysc_dol_planszy
		rysuj_postac_kucajaca
		min=13
		max=21
		stan=2
	fi

	tput setab 2
	tput setaf 2
	tput cup 25 80
	read -rsn1 -d '' t
done

#Rafał Byczek
#Dawid Rączka