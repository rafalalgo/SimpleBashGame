#!/bin/bash

#prepare
tput civis
tput bold
clear

#zmienne globalne

#tablica		#tu trzymamy co jest na planszy
#kolor_znaku	#tu trzymamy numer koloru znaku
#kolor_tla		#tu trzymamy numer koloru tla
#RURKOWIEC		#tu trzymamy R w komorce jezeli jest rurkowiec na polu

#odwolywanie tablica[$[i*K+j]] zwraca znak w i tym wierszu i j tej kolumnie

#	 Oznaczenia
#	 s - niebo
# 	 ^ - trawa
# 	 p - pnie drzew
#	 k - korona drzew
#	 o - sloneczko
#	 R - rurkowiec

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

#funkcje

rysuj_postac_kucajaca() #funkcja rysujaca postac w trybie kucania
{
	# GŁOWA
	
	tput setab 7; tput setaf 7; tput cup 14 9;  echo "#";
	tput setab 3; tput setaf 3;	tput cup 14 10; echo " ";
	tput setab 7; tput setaf 7; tput cup 14 11; echo "#";
	tput setab 3; tput setaf 3; tput cup 15 8;  echo " ";
	tput setab 9; tput setaf 9; tput cup 15 9;  echo "*";
	tput setab 3; tput setaf 3; tput cup 15 10; echo " ";
	tput setab 9; tput setaf 9; tput cup 15 11; echo "*";
	tput setab 3; tput setaf 3; tput cup 15 12; echo " ";
	tput setab 3; tput setaf 3; tput cup 16 9;  echo "[-]";
	tput setab 1; tput setaf 1; tput cup 17 9;  echo ">-<";
	
	#KLATKA PIERSIOWA
	
	tput setab 9; tput setaf 9; tput cup 18 7;  echo "   ";
	tput setab 7; tput setaf 7; tput cup 18 10; echo " ";
	tput setab 9; tput setaf 9; tput cup 18 11; echo "  "
	tput setab 9; tput setaf 9; tput cup 19 6;  echo "   ";
	tput setab 3; tput setaf 3; tput cup 19 9;  echo "=";
	tput setab 7; tput setaf 7; tput cup 19 10; echo " ";
	tput setab 9; tput setaf 9; tput cup 19 11; echo "   ";
	tput setab 3; tput setaf 3; tput cup 19 14; echo "=";
	tput setab 7; tput setaf 7; tput cup 20 7;  echo " ";
	tput setab 9; tput setaf 9; tput cup 20 8;  echo "     ";
	tput setab 7; tput setaf 7; tput cup 21 7;  echo " ";
	tput setab 9; tput setaf 9; tput cup 21 8;  echo "  ";
	tput setab 7; tput setaf 7; tput cup 21 11; echo "   ";
}

rysuj_postac_stojaca() #funkcja rysujaca postac w trybie stojacym
{
	# GŁOWA
	
	tput setab 7; tput setaf 7; tput cup 11 9;  echo "#";
	tput setab 3; tput setaf 3; tput cup 11 10; echo " ";
	tput setab 7; tput setaf 7; tput cup 11 11; echo "#";
	tput setab 3; tput setaf 3; tput cup 12 8;  echo " ";
	tput setab 9; tput setaf 9; tput cup 12 9;  echo "*";
	tput setab 3; tput setaf 3; tput cup 12 10; echo " ";
	tput setab 9; tput setaf 9; tput cup 12 11; echo "*";
	tput setab 3; tput setaf 3; tput cup 12 12; echo " ";
	tput setab 3; tput setaf 3; tput cup 13 9;  echo "[-]";
	tput setab 1; tput setaf 1; tput cup 14 9;  echo ">-<";
	
	#KLATKA PIERSIOWA
	
	tput setab 9; tput setaf 9; tput cup 15 7;  echo "   ";
	tput setab 7; tput setaf 7; tput cup 15 10; echo " ";
	tput setab 9; tput setaf 9; tput cup 15 11; echo "   ";
	tput setab 9; tput setaf 9; tput cup 16 6;  echo "    ";
	tput setab 7; tput setaf 7; tput cup 16 10; echo " ";
	tput setab 9; tput setaf 9; tput cup 16 11; echo "    ";
	tput setab 3; tput setaf 3; tput cup 17 6;  echo "||";
	tput setab 9; tput setaf 9; tput cup 17 8;  echo "     ";
	tput setab 3; tput setaf 3; tput cup 17 13; echo "||";
	
	#SPODNIE
	
	tput setab 9; tput setaf 9; tput cup 18 8;  echo -n "  ";
	tput setab 2; tput setaf 2;                 echo -n "^";
	tput setab 9; tput setaf 9;				    echo -n "  "; 
	tput setab 7; tput setaf 7; tput cup 19 7;  echo -n "   ";
	tput setab 2; tput setaf 2;				 	echo -n "^";
	tput setab 7; tput setaf 7;				 	echo -n "   ";
}

wyczysc_dol_planszy() #czyszczenie postaci w poprzednim typie celem narysowania nowej
{
	for((i=$[M+1];i<=$W;i++))
	do
		for((j=0;j<=14;j++))
		do
			zmienna=$zmienna"^"
		done
		tput setab 2; tput setaf 2; tput cup $i 0; echo $zmienna;
		zmienna="";
	done

	for((i=10;i<=$M;i++))
	do
		for((j=0;j<=14;j++))
		do
			zmienna=$zmienna"s"
		done
		tput setab 4; tput setaf 4; tput cup $i 0; echo $zmienna;
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

wypis_koncowego_wyniku()
{
	tput cup 1 $[58 - ${#wynik}]; tput setab 1; tput setaf 7; echo -n "Twoj koncowy wynik to "$wynik
}

wypis_wyniku()
{
	tput cup 1 $[57 - ${#wynik}]; tput setab 1; tput setaf 7; echo -n "Twoj aktualny wynik to "$wynik
}

rysuj_rurkowca()
{
	KOLUMNA=$RANDOM;
	WIERSZ=76;
	let "KOLUMNA %= 12";
	KOLUMNA=$[KOLUMNA+10];
	tput cup $KOLUMNA $WIERSZ;
	RURKOWIEC[$[KOLUMNA*K+WIERSZ]]="R";
	RURKOWIEC[$[KOLUMNA*K+WIERSZ+1]]="R";
	RURKOWIEC[$[KOLUMNA*K+WIERSZ+2]]="R";
	RURKOWIEC[$[KOLUMNA*K+WIERSZ+3]]="R";
	tput setab 1;
	tput setaf 1;
	echo "    ";
	tput cup $[KOLUMNA+1] $WIERSZ;
	RURKOWIEC[$[$[KOLUMNA+1]*K+WIERSZ]]="R";
	RURKOWIEC[$[$[KOLUMNA+1]*K+WIERSZ+1]]="R";
	RURKOWIEC[$[$[KOLUMNA+1]*K+WIERSZ+2]]="R";
	RURKOWIEC[$[$[KOLUMNA+1]*K+WIERSZ+3]]="R";
	tput setab 1;
	tput setaf 1;
	echo "    ";
}

uaktualnij()
{
	for((i=1;i<=$W;i++))
	do
		for((j=1;j<=$K;j++))
		do
			if [ "${RURKOWIEC[$[i*K+j]]}" == "R" ]
			then
				
				tput setab ${kolor_tla[$[i*K+j]]};
				tput setaf ${kolor_znaku[$[i*K+j]]};
				
				tput cup $i $j
				
				if [ ${tablica[$[i*K+j]]} == "p" ]
				then
					echo -n " "
				elif [ ${tablica[$[i*K+j]]} == "k" ]
				then
					echo -n "*"
				else
					echo -n ${tablica[$[i*K+j]]}
				fi
				
				RURKOWIEC[$[i*K+j]]="";
				
				if [ $[j-1] -ne 0 ]
				then
					RURKOWIEC[$[i*K+j-1]]="R";
					tput setab 1;
					tput setaf 1;
					tput cup $i $[j-1];
					echo " ";
				fi
			fi
		done
	done
}

#program glowny

welcome;
rysowanie_planszy;
rysuj_postac_stojaca;
rysuj_rurkowca;

while [ $controller -eq 1 ] || [ $controller -eq 2 ] ;
do
	wypis_wyniku;
	
	if [ $controller -eq 1 ] && [ $stan -eq 2 ];
	then
		wyczysc_dol_planszy;
		rysuj_postac_stojaca;
		min=11;
		max=19;
		stan=1;
	fi
	
	if [ $controller -eq 2 ] && [ $stan -eq 1 ];
	then
		wyczysc_dol_planszy;
		rysuj_postac_kucajaca;
		min=13;
		max=21;
		stan=2;
	fi
	
	uaktualnij;
	
	tput setab 2; tput setaf 2; tput cup 25 84; read -rsn1 -d '' controller;
done

#kontrolny_wypis_tablicy_zgodny_z_kolorami;

#Rafał Byczek
#Dawid Rączka