#!/bin/bash

#prepare
tput civis
tput bold
clear

#zmienne globalne

#tablica		#tu trzymamy co jest na planszy
#kolor_znaku	#tu trzymamy numer koloru znaku
#kolor_tla		#tu trzymamy numer koloru tla
#komin			#tu trzymamy K gdy na polu jest cos z komina
#kolor_zk		#tu trzymamy kolor znaku na polu komina
#kolor_tk		#tu trzymamy kolor tla na polu komina

#odwolywanie tablica[$[i*K+j]] zwraca znak w i tym wierszu i j tej kolumnie

#	 Oznaczenia
#	 s - niebo
# 	 ^ - trawa
# 	 p - pnie drzew
#	 k - korona drzew
#	 o - sloneczko

#######################################################################################

K=80;			#liczba kolumn planszy
M=12;			#liczba wierszy planszy niebo
W=22;			#liczba wszystkich wierszy
stan=1;			#informacja jaka postac wyswietlona 1 - stojaca 2 - kucajaca
min=11;			#zakres zasiegu postaci gorny liczac od gory, ukatulniane wraz z stanem
max=21;			#zakres zasiegu postac dolny liczac od dolu, uaktualniany wraz z stanem
szerokosc=14;	#zakres postaci w prawo
controller=1;	#akcja pobrana od gracza
wynik=0;		#aktualny wynik gracza
y=21; 			#wspolrzedna y-kowa stop postaci
jaka=2;			#typ postaci do zmazania
gameover=0;		#1 gdy koniec gdy, bo gracz dotknal komin
wys_komina=6;	#wysokosc rysowanego kominu

#funkcje

rysuj_komingorny()
{
    for((j=1;j<=$1;j++))
	do
		komin[$[j*K+73]]="K";
		kolor_zk[$[j*K+73]]=1;
		kolor_tk[$[j*K+73]]=1;
		komin[$[j*K+74]]="K";
		kolor_zk[$[j*K+74]]=3;
		kolor_tk[$[j*K+74]]=3;
		komin[$[j*K+75]]="K";
		kolor_zk[$[j*K+75]]=6;
		kolor_tk[$[j*K+75]]=6;
		komin[$[j*K+76]]="K";
		kolor_zk[$[j*K+76]]=4;
		kolor_tk[$[j*K+76]]=4;
		komin[$[j*K+77]]="K";
		kolor_zk[$[j*K+77]]=5;
		kolor_tk[$[j*K+77]]=5;
	done
}
 
rysuj_komindolny()
{
    for((j=22;j>$[22-$1];j--))
	do
		komin[$[j*K+73]]="K";
		kolor_zk[$[j*K+73]]=1;
		kolor_tk[$[j*K+73]]=1;
		komin[$[j*K+74]]="K";
		kolor_zk[$[j*K+74]]=3;
		kolor_tk[$[j*K+74]]=3;
		komin[$[j*K+75]]="K";
		kolor_zk[$[j*K+75]]=6;
		kolor_tk[$[j*K+75]]=6;
		komin[$[j*K+76]]="K";
		kolor_zk[$[j*K+76]]=4;
		kolor_tk[$[j*K+76]]=4;
		komin[$[j*K+77]]="K";
		kolor_zk[$[j*K+77]]=5;
		kolor_tk[$[j*K+77]]=5;                         
	done
}
 
wyswietl_komin()
{
	for((i=1;i<=$W;i++))
	do
		for((j=1;j<=$K;j++))
		do
			if [ "${komin[$[i*K]+$j]}" == "K" ]
			then
				tput setab ${kolor_tk[$[i*K+j]]};
				tput setaf ${kolor_zk[$[i*K+j]]};
				tput cup $i $j
				echo -n " "
			fi
		done
	done
}



rysuj_postac_skaczaca() #funkcja rysujaca postac w trybie skoku - $1=y wysokosci na jakiej znajdują się stopy
{
	# GŁOWA
	tput setab 7; tput setaf 7; tput cup $[$1-6] 9;  echo "#";
	tput setab 3; tput setaf 3;	tput cup $[$1-6] 10; echo " ";
	tput setab 7; tput setaf 7; tput cup $[$1-6] 11; echo "#";
	tput setab 3; tput setaf 3; tput cup $[$1-5] 8;  echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-5] 9;  echo "*";
	tput setab 3; tput setaf 3; tput cup $[$1-5] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-5] 11; echo "*";
	tput setab 3; tput setaf 3; tput cup $[$1-5] 12; echo " ";
	tput setab 3; tput setaf 3; tput cup $[$1-4] 9;  echo "[-]";
	tput setab 1; tput setaf 1; tput cup $[$1-3] 9;  echo ">-<";
	
	#KLATKA PIERSIOWA
	tput setab 3; tput setaf 3; tput cup $[$1-2] 6;  echo "=";
	tput setab 9; tput setaf 9; tput cup $[$1-2] 7;  echo "   ";
	tput setab 7; tput setaf 7; tput cup $[$1-2] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-2] 11; echo "   "
	tput setab 3; tput setaf 3; tput cup $[$1-2] 14;  echo "=";
	tput setab 9; tput setaf 9; tput cup $[$1-1] 8;  echo "  ";
	tput setab 7; tput setaf 7; tput cup $[$1-1] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-1] 11; echo "  ";
	tput setab 7; tput setaf 7; tput cup $1 6;  echo " ";
	tput setab 9; tput setaf 9; tput cup $1 7;  echo "       ";
	tput setab 7; tput setaf 7; tput cup $1 14;  echo " ";
}

rysuj_postac_kucajaca() #funkcja rysujaca postac w trybie kucania - $1=y wysokosci na jakiej znajdują się stopy
{
	# GŁOWA
	tput setab 7; tput setaf 7; tput cup $[$1-7] 9;  echo "#";
	tput setab 3; tput setaf 3;	tput cup $[$1-7] 10; echo " ";
	tput setab 7; tput setaf 7; tput cup $[$1-7] 11; echo "#";
	tput setab 3; tput setaf 3; tput cup $[$1-6] 8;  echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-6] 9;  echo "*";
	tput setab 3; tput setaf 3; tput cup $[$1-6] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-6] 11; echo "*";
	tput setab 3; tput setaf 3; tput cup $[$1-6] 12; echo " ";
	tput setab 3; tput setaf 3; tput cup $[$1-5] 9;  echo "[-]";
	tput setab 1; tput setaf 1; tput cup $[$1-4] 9;  echo ">-<";
	
	#KLATKA PIERSIOWA
	
	tput setab 9; tput setaf 9; tput cup $[$1-3] 7;  echo "   ";
	tput setab 7; tput setaf 7; tput cup $[$1-3] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-3] 11; echo "  "
	tput setab 9; tput setaf 9; tput cup $[$1-2] 6;  echo "   ";
	tput setab 3; tput setaf 3; tput cup $[$1-2] 9;  echo "=";
	tput setab 7; tput setaf 7; tput cup $[$1-2] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-2] 11; echo "   ";
	tput setab 3; tput setaf 3; tput cup $[$1-2] 14; echo "=";
	tput setab 7; tput setaf 7; tput cup $[$1-1] 7;  echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-1] 8;  echo "     ";
	tput setab 7; tput setaf 7; tput cup $1 7;  echo " ";
	tput setab 9; tput setaf 9; tput cup $1 8;  echo "  ";
	tput setab 7; tput setaf 7; tput cup $1 11; echo "   ";
}

rysuj_postac_stojaca() #funkcja rysujaca postac w trybie stojacym - $1=y wysokosci na jakiej znajdują się stopy
{
	# GŁOWA
	
	tput setab 7; tput setaf 7; tput cup $[$1-8] 9;  echo "#";
	tput setab 3; tput setaf 3; tput cup $[$1-8] 10; echo " ";
	tput setab 7; tput setaf 7; tput cup $[$1-8] 11; echo "#";
	tput setab 3; tput setaf 3; tput cup $[$1-7] 8;  echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-7] 9;  echo "*";
	tput setab 3; tput setaf 3; tput cup $[$1-7] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-7] 11; echo "*";
	tput setab 3; tput setaf 3; tput cup $[$1-7] 12; echo " ";
	tput setab 3; tput setaf 3; tput cup $[$1-6] 9;  echo "[-]";
	tput setab 1; tput setaf 1; tput cup $[$1-5] 9;  echo ">-<";
	
	#KLATKA PIERSIOWA
	
	tput setab 9; tput setaf 9; tput cup $[$1-4] 7;  echo "   ";
	tput setab 7; tput setaf 7; tput cup $[$1-4] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-4] 11; echo "   ";
	tput setab 9; tput setaf 9; tput cup $[$1-3] 6;  echo "    ";
	tput setab 7; tput setaf 7; tput cup $[$1-3] 10; echo " ";
	tput setab 9; tput setaf 9; tput cup $[$1-3] 11; echo "    ";
	tput setab 3; tput setaf 3; tput cup $[$1-2] 6;  echo "||";
	tput setab 9; tput setaf 9; tput cup $[$1-2] 8;  echo "     ";
	tput setab 3; tput setaf 3; tput cup $[$1-2] 13; echo "||";
	
	#SPODNIE
	
	tput setab 9; tput setaf 9; tput cup $[$1-1] 8;  echo -n "  ";
	tput setab 2; tput setaf 2;                 echo -n "^";
	tput setab 9; tput setaf 9;				    echo -n "  "; 
	tput setab 7; tput setaf 7; tput cup $1 7;  echo -n "   ";
	tput setab 2; tput setaf 2;				 	echo -n "^";
	tput setab 7; tput setaf 7;				 	echo -n "   ";
}

wyczysc_postac_stojaca()
{
	for((i=$[$1-7];i<=$1;i++))
	do
		for((j=6;j<=13;j++))
		do
			zmienna=$zmienna""${tablica[$[$i*K]+$j]}
		done
		tput setab ${kolor_tla[$[$i*K]+6]}; tput setaf ${kolor_znaku[$[$i*K]+6]}; tput cup $i 0; echo $zmienna;
		zmienna="";
	done
}

wyczysc_postac_kucajaca()
{
	for((i=$1-7;i<=$1;i++))
	do
		for((j=6;j<=13;j++))
		do
			zmienna=$zmienna""${tablica[$[$i*K]+$j]}
		done
		tput setab ${kolor_tla[$[$i*K]+6]}; tput setaf ${kolor_znaku[$[$i*K]+6]}; tput cup $i 0; echo $zmienna;
		zmienna="";
	done
}

wyczysc_postac_skaczaca()
{
	for((i=$[$1-7];i<=$1;i++))
	do
		for((j=6;j<=13;j++))
		do
			zmienna=$zmienna""${tablica[$[$i*K]+$j]}
		done
		tput setab ${kolor_tla[$[$i*K]+6]}; tput setaf ${kolor_znaku[$[$i*K]+6]}; tput cup $i 0; echo $zmienna;
		zmienna="";
	done
}

welcome()
{
	tput setaf 4;
	
	echo -e "\n\n";
	echo "       OOO       OOO      OOOOO       OOOOOOOO    OOOOOOO     OOOOO";
	echo "       OOOO     OOOO     OOOOOOO     OOOOOOOOOO   OOOOOOO    OOOOOOO";
	echo "       OOOOO   OOOOO    OOO   OOO    OOO    OOO     OOO     OOO   OOO";
	echo "       OOOOOO OOOOOO   OOO     OOO   OOO    OOO     OOO    OOO     OOO";
	echo "       OOO OOOOO OOO   OOOOOOOOOOO   OOOOOOOOOO     OOO    OOO     OOO";
	echo "       OOO  OOO  OOO   OOOOOOOOOOO   OOOOOOOO       OOO    OOO     OOO";
	echo "       OOO   O   OOO   OOO     OOO   OOO  OOO       OOO     OOO   OOO";
	echo "       OOO       OOO   OOO     OOO   OOO   OOO    OOOOOOO    OOOOOOO";
	echo "       OOO       OOO   OOO     OOO   OOO    OOO   OOOOOOO     OOOOO";
	echo -e "\n\n";
	
	tput setaf 4; echo "      			   JKM SPECIAL EDITION";
	tput setaf 4; echo -e "\n\n";
	echo "              Nacisnij dowolny klawisz zeby rozpoczac rozgrywke.";
	read zmienna;
}

wyczysc_dol_planszy() #czyszczenie postaci w poprzednim typie celem narysowania nowej
{	
	for((i=$min;i<=$max;i++))
	do
		for((j=0;j<=18;j++))
		do
			if [ $i -le $M ]
			then
				zmienna=$zmienna"s";
			else
				zmienna=$zmienna"^";
			fi
		done
		
		if [ $i -le $M ]
		then
			tput setab 4; tput setaf 4; tput cup $i 0; echo $zmienna;
		else
			tput setab 2; tput setaf 2; tput cup $i 0; echo $zmienna;
		fi
		zmienna="";
	done
}

rysowanie_planszy()
{
	#wstepne zaladowanie tla do tablicy
	
	for((i=1;i<=$M;i++))
	do
		for((j=1;j<=$K;j++))
		do
			tablica[$[i*K+j]]="s";
			kolor_tla[$[i*K+j]]=4;
			kolor_znaku[$[i*K+j]]=4;
		done
	done

	for((i=$[M+1];i<=$W;i++))
	do
		for((j=1;j<=$K;j++))
		do
			tablica[$[i*K+j]]="^";
			kolor_tla[$[i*K+j]]=2;
			kolor_znaku[$[i*K+j]]=2;
		done
	done
	
	#wypis podstawowego tla
	
	for((i=1;i<=$M;i++))
	do
		for((j=1;j<=$K;j++))
		do
			zmienna=$zmienna"s"
		done
		tput setab 4; tput setaf 4; echo $zmienna;
		zmienna="";
	done

	for((i=$[M+1];i<=$W;i++))
	do
		for((j=1;j<=$K;j++))
		do
			zmienna=$zmienna"^"
		done
		tput setab 2; tput setaf 2; echo $zmienna;
		zmienna="";
	done

	#rysowanie pni drzew
	
	for((h=1;h<=3;h++))
	do
		for((i=10;i<=14;i++))
		do
			for((j=$[h*20+9];j<=$[h*20+11];j++))
			do
				tput setab 0; tput setaf 0; tput cup $i $j; echo -n " "; tablica[$[i*K+j]]="p";
				kolor_tla[$[i*K+j]]=0;
				kolor_znaku[$[i*K+j]]=0;
			done
		done
	done

	#rysowanie koron drzew

	for((h=1;h<=3;h++))
	do
		for((j=$[h*20+7];j<=$[h*20+13];j++))
		do
			tput setab 2; tput setaf 2; tput cup 4 $j; echo -n "*"; tablica[$[4*K+j]]="k";
			kolor_tla[$[4*K+j]]=2;
			kolor_znaku[$[4*K+j]]=2;
		done

		for((j=$[h*20+7];j<=$[h*20+13];j++))
		do
			tput setab 2; tput setaf 2; tput cup 9 $j; echo -n "*"; tablica[$[9*K+j]]="k";
			kolor_tla[$[9*K+j]]=2;
			kolor_znaku[$[9*K+j]]=2;
		done

		for((i=8;i>=5;i--))
		do
			for((j=$[h*20+6];j<=$[h*20+14];j++))
			do
				tput setab 2; tput setaf 2; tput cup $i $j; echo -n "*"; tablica[$[i*K+j]]="k";
				kolor_tla[$[i*K+j]]=2;
				kolor_znaku[$[i*K+j]]=2;
			done
		done
	done

	#rysowanie slonca

	for((i=3;i<=4;i++))
	do
		for((j=$[4-i+1];j<$[4+i-1];j++))
		do
			tput setab 3; tput setaf 3; tput cup $[i - 2] $[j+1]; echo -n "o"; tablica[$[$[i-2]*K+$[j+1]]]="o";
			kolor_tla[$[$[i-2]*K+$[j+1]]]=3;
			kolor_znaku[$[$[i-2]*K+$[j+1]]]=3;
		done
	done

	for((j=$[4-3+1];j<$[4+3-1];j++))
	do
		tput setab 3; tput setaf 3; tput cup 3 $[j+1]; echo -n "o"; tablica[$[3*K+$[j+1]]]="o";
		kolor_tla[$[3*K+$[j+1]]]=3;
		kolor_znaku[$[3*K+$[j+1]]]=3;
	done
}

kontrolny_wypis_tablicy_zgodny_z_kolorami()
{
	for((i=1;i<=$W;i++))
	do
		for((j=1;j<=$K;j++))
		do
			tput setab ${kolor_tla[$[i*K+j]]};
			tput setaf ${kolor_znaku[$[i*K+j]]};
			
			if [ ${tablica[$[i*K+j]]} == "p" ]
			then
				echo -n " "
			elif [ ${tablica[$[i*K+j]]} == "k" ]
			then
				echo -n "*"
			else
				echo -n ${tablica[$[i*K+j]]}
			fi
		done
		echo ""
	done
}

wypis_wyniku()
{
	tput cup 1 $[57 - ${#wynik}]; tput setab 1; tput setaf 7; echo -n "Twoj aktualny wynik to "$wynik
}

sprawdz_czy_punkt()
{
	tak=0;
	
	for((i=1;i<=$[min-1];i++))
	do
		if [ "${komin[$[i*K+15]]}" == "K" ]
		then
			tak=1;
		fi
	done
	
	for((i=$[max+1];i<=22;i++))
	do
		if [ "${komin[$[i*K+15]]}" == "K" ]
		then
			tak=1;
		fi
	done
}

sprawdz_czy_zabity()
{
	for((i=$min;i<=$max;i++))
	do
		if [ "${komin[$[i*K+15]]}" == "K" ]
		then
			gameover=1;
		fi
	done
}

gameover()
{
	clear;
	tput setab 2;
	tput setaf 2;
	clear;
	echo "KURWA PRZEGRALES PAJACU"
	exit;
}

uaktualnij()
{
	for((i=1;i<=$W;i++))
	do
		for((j=1;j<=$[K-5];j++))
		do
			if [ "${komin[$[i*K]+$j]}" == "K" ]
			then
				komin[$[i*K]+$[j+4]]="";
				komin[$[i*K]+$[j-1]]="K";
				l=$[j+4];
				tput setab ${kolor_tla[$[$[i*K]+l]]};
				tput setaf ${kolor_znaku[$[$[i*K]+l]]};
				tput cup $i $l;
				
				if [ ${tablica[$[i*K+l]]} == "p" ]
				then
					echo -n " "
				elif [ ${tablica[$[i*K+l]]} == "k" ]
				then
					echo -n "*"
				else
					echo -n ${tablica[$[i*K+l]]}
				fi
				
				if [ $[j-1] -ne 0 ]
				then
					kolor_tk[$[$i*$K+$[j-1]]]=${kolor_tk[$[$i*$K+$l]]};
					kolor_zk[$[$i*$K+$[j-1]]]=${kolor_zk[$[$i*$K+$l]]};
					
					tput setab ${kolor_tk[$[$i*$K+$[j-1]]]};
					tput setaf ${kolor_zk[$[$i*$K+$[j-1]]]};
					tput cup $i $[j-1]
					echo -n " "
					j=$[j+5];
				fi
				
				if [ $[j-1] -eq 0 ]
				then
					for((i=22;i>$[22-wys_komina];i--))
					do
						for((j=1;j<=5;j++))
						do
							komin[$[i*K]+$j]="";
							tput setab ${kolor_tla[$[$[i*K]+j]]};
							tput setaf ${kolor_znaku[$[$[i*K]+j]]};
							tput cup $i $j;
							
							if [ "${tablica[$[i*K+j]]}" == "p" ]
							then
								echo -n " "
							elif [ "${tablica[$[i*K+j]]}" == "k" ]
							then
								echo -n "*"
							else
								echo -n ${tablica[$[i*K+j]]}
							fi
						done
					done
				fi
			fi
		done
	done
	
}

#program glowny

welcome;
rysowanie_planszy;
rysuj_postac_kucajaca $y;
jaka=1;
min=14;
max=21;

wys_komina=9;
rysuj_komindolny $wys_komina;
wyswietl_komin;

while : 
do
	sprawdz_czy_zabity;
	
	if [ $gameover -eq 1 ]
	then
		gameover;
	fi
	
	sprawdz_czy_punkt;
	
	if [ $tak -eq 1 ]
	then
		wynik=$[wynik+1];
	fi
	
	wypis_wyniku;
	
	read -rsn1 -d '' PRESS
	
	case "$PRESS" in
		A) y=$[y-1] ;; # Up
		B) y=$[y+1] ;; # Down
		1) exit 1;
	esac
	
	if [ $y -le 21 ] && [ $y -ge 19 ]
	then
		wyczysc_dol_planszy;
		rysuj_postac_kucajaca $y;
		max=$y;
		min=$[y-7];
		jaka=1;
	fi
	if [ $y -le 18 ] && [ $y -ge 14 ]
	then
		wyczysc_dol_planszy;
		rysuj_postac_stojaca $y;
		max=$y;
		min=$[y-8];
		jaka=2;
	fi
	if [ $y -le 13 ] && [ $y -ge 10 ]
	then
		wyczysc_dol_planszy;
		rysuj_postac_skaczaca $y;
		max=$y;
		min=$[y-6];
		jaka=3;
	fi
	
	if [ $y -le 9 ]
	then
		y=$[y+1];
		wyczysc_dol_planszy;
		rysuj_postac_skaczaca $y;
	fi
	
	if [ $y -ge 22 ]
	then
		y=$[y-1];
		wyczysc_dol_planszy;
		rysuj_postac_kucajaca $y;
	fi
	
	uaktualnij;
done

#kontrolny_wypis_tablicy_zgodny_z_kolorami;

#Rafał Byczek
#Dawid Rączka