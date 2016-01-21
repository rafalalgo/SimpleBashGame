#!/bin/bash

#prepare
tput civis
tput bold
clear

#zmienne globalne

#tablica		#tu trzymamy co jest na planszy
#kolor_znaku	#tu trzymamy numer koloru znaku
#kolor_tla		#tu trzymwamy numer koloru tla
#komin			#tu trzymamy K gdy na polu jest cos z komina
#kolor_zk		#tu trzymamy kolor znaku na polu komina
#kolor_tk		#tu trzymamy kolor tla na polu komina
#slina          #tu trzymamy D gdy na polu jest slina

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
y=21; 			#wspolrzedna y-kowa stop postaci
jaka=2;			#typ postaci do zmazania
gameover=0;		#1 gdy koniec gdy, bo gracz dotknal komin
wys_komina=6;	#wysokosc rysowanego kominu
H=11;
CO_ILE=11;
last=1;
last_down=9;
last_up=4;

#funkcje

rysuj_glos()
{
	for((p=$1;p<=$[$1 + 1];p++))
	do
		komin[$[p*K+70]]="G";
		kolor_zk[$[p*K+70]]=7;
		kolor_tk[$[p*K+70]]=7;
		komin[$[p*K+71]]="G";
		kolor_zk[$[p*K+71]]=7;
		kolor_tk[$[p*K+71]]=7;
		komin[$[p*K+72]]="G";
		kolor_zk[$[p*K+72]]=7;
		kolor_tk[$[p*K+72]]=7;
		komin[$[p*K+73]]="G";
		kolor_zk[$[p*K+73]]=7;
		kolor_tk[$[p*K+73]]=7;
	done
}

rysuj_komingorny()
{
    for((p=1;p<=$1;p++))
	do
		komin[$[p*K+75]]="K";
		kolor_zk[$[p*K+75]]=1;
		kolor_tk[$[p*K+75]]=1;
		komin[$[p*K+76]]="K";
		kolor_zk[$[p*K+76]]=3;
		kolor_tk[$[p*K+76]]=3;
		komin[$[p*K+77]]="K";
		kolor_zk[$[p*K+77]]=6;
		kolor_tk[$[p*K+77]]=6;
		komin[$[p*K+78]]="K";
		kolor_zk[$[p*K+78]]=4;
		kolor_tk[$[p*K+78]]=4;
		komin[$[p*K+79]]="K";
		kolor_zk[$[p*K+79]]=5;
		kolor_tk[$[p*K+79]]=5;
	done
}
 
rysuj_komindolny()
{
    for((p=22;p>$[23-$1];p--))
	do
		komin[$[p*K+75]]="K";
		kolor_zk[$[p*K+75]]=1;
		kolor_tk[$[p*K+75]]=1;
		komin[$[p*K+76]]="K";
		kolor_zk[$[p*K+76]]=3;
		kolor_tk[$[p*K+76]]=3;
		komin[$[p*K+77]]="K";
		kolor_zk[$[p*K+77]]=6;
		kolor_tk[$[p*K+77]]=6;
		komin[$[p*K+78]]="K";
		kolor_zk[$[p*K+78]]=4;
		kolor_tk[$[p*K+78]]=4;
		komin[$[p*K+79]]="K";
		kolor_zk[$[p*K+79]]=5;
		kolor_tk[$[p*K+79]]=5;                         
	done
}
 
wyswietl_komin()
{
	for((ss=1;ss<=$W;ss++))
	do
		for((p=70;p<$K;p++))
		do
			if [ "${komin[$[ss*K]+$p]}" == "K" ]
			then
				tput setab ${kolor_tk[$[ss*K+p]]};
				tput setaf ${kolor_zk[$[ss*K+p]]};
				tput cup $ss $p
				echo -n " "
			fi
			if [ "${komin[$[ss*K]+$p]}" == "G" ]
			then
				tput setab ${kolor_tk[$[ss*K+p]]};
				tput setaf ${kolor_zk[$[ss*K+p]]};
				tput cup $ss $p
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

rysuj_postac_stojaca2() #funkcja rysujaca postac w trybie stojacym - $1=y wysokosci na jakiej znajdują się stopy
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
	tput setab 4; tput setaf 4;                 echo -n " ";
	tput setab 9; tput setaf 9;				    echo -n "  "; 
	tput setab 7; tput setaf 7; tput cup $1 7;  echo -n "   ";
	tput setab 4; tput setaf 4;				 	echo -n " ";
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

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

wyczysc()
{
    tan=1;   
    min=11;      
    max=21;  
    szerokosc=14;    
    controller=1;    
    wynik=0;     
    y=21;            
    jaka=2;      
    gameover=0;  
    wys_komina=6;
    H=11;
    CO_ILE=11;
    last=1;
    last_down=9;
    last_up=4;

    for((i=1;i<=$W;i++))
    do
        for((j=1;j<=$K;j++))
        do
            komin[$[i*K+j]]="";
            kolor_zk[$[i*K+j]]="";
            kolor_tk[$[i*K+j]]="";
            slina[$[i*K+j]]="";
        done
    done
}

welcome()
{
    tout setab 1;
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
	echo -e "\n";
	echo "             Obsługa postaci klawiszami [w] i [s], 'TFU geje' [d]";
	echo -e "\n"
	read -n1 zmienna;
}

wyczysc_dol_planszy() #czyszczenie postaci w poprzednim typie celem narysowania nowej
{	
	for((i=$min;i<=$max;i++))
	do
		for((j=0;j<=14;j++))
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
			tput setab 3; tput setaf 3; tput cup $[i-2] $[j+1]; echo -n "o"; tablica[$[$[i-2]*K+$[j+1]]]="o";
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
	for((L=0;L<$[57 - ${#wynik}];L++))
	do
		tput setab 1; tput setaf 7; tput cup 0 $L; echo -n " ";
	done
	
	tput cup 0 $[57 - ${#wynik}]; tput setab 1; tput setaf 7; echo -n "Twoj aktualny wynik to "$wynik; tput cup 22 82;
}

pluj()
{
    if [ $y -le 21 ] && [ $y -ge 19 ] #jezeli kuca
    then
        slina[$[K*$[$1-5]+12]]="D";
        tput setab 7; tput setaf 7; tput cup $[$1-5] 12;  echo " ";
    fi

    if [ $y -le 18 ] && [ $y -ge 14 ] #jezeli stoi
    then
        slina[$[K*$[$1-6]+12]]="D";
        tput setab 7; tput setaf 7; tput cup $[$1-6] 12;  echo " ";
    fi
    
    if [ $y -le 13 ] && [ $y -ge 10 ] #jezeli skacze
    then
        slina[$[K*$[$1-4]+12]]="D";
        tput setab 7; tput setaf 7; tput cup $[$1-4] 12;  echo " ";
    fi
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
	
	for((jj=8;jj<=15;jj++))
	do
		for((i=$min;i<=$max;i++))
		do
			if [ "${komin[$[i*K+jj]]}" == "G" ]
			then
				wynik=$[wynik+1];
				for((sss=$[i-2];sss<=$[i+2];sss++))
				do
					for((rrr=$jj;rrr<=$[jj+3];rrr++))
					do
						komin[$[sss*K+rrr]]="";
						tput setab ${kolor_tla[$[$[sss*K]+rrr]]};
						tput setaf ${kolor_znaku[$[$[sss*K]+rrr]]};
						tput cup $sss $rrr
						
						if [ "${tablica[$[sss*K+rrr]]}" == "p" ]
						then
							echo -n " "
						elif [ "${tablica[$[sss*K+rrr]]}" == "k" ]
						then
							echo -n "*"
						else
							echo -n ${tablica[$[sss*K+rrr]]}
						fi
					done
				done
				
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
				if [ $y -le 13 ] && [ $y -ge 8 ]
				then
					wyczysc_dol_planszy;
					rysuj_postac_skaczaca $y;
					max=$y;
					min=$[y-6];
					jaka=3;
				fi
				
				if [ $y -le 7 ]
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
			fi
		done
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
	for((j=6;j<=14;j++))
	do
		for((i=$min;i<=$max;i++))
		do
			if [ "${komin[$[i*K+j]]}" == "K" ]
			then
				gameover=1;
			fi
		done
	done
}

gameover()
{
	clear;
	tput setab 4;
	tput setaf 9;
	clear;
	tput setaf 2;
	echo -e "\n\n";
	echo "          #####                                                      ### ";
	echo "         #     #   ##   #    # ######     ####  #    # ###### #####  ###";
	echo "         #        #  #  ##  ## #         #    # #    # #      #    # ###";
	echo "         #  #### #    # # ## # #####     #    # #    # #####  #    #  # ";
	echo "         #     # ###### #    # #         #    # #    # #      #####     ";
	echo "         #     # #    # #    # #         #    #  #  #  #      #   #  ###";
	echo "          #####  #    # #    # ######     ####    ##   ###### #    # ###"
	echo -e "\n";
	echo -e "\n";
	echo "	          	  CELEM ŻYCIA NIE JEST PRZEŻYCIE! ";
	printf "\n"
	tput setaf 3; printf "      			           TWÓJ WYNIK: ";
	printf $wynik
	printf "\n\n"
	echo -e "                      Wciśnij klawisz [r] aby zagrać poniwnie";
	echo "                     lub dowolny inny klawisz aby wyjść z gry.";
    printf "\n"

    rysuj_postac_stojaca2 20;

	tput setab 9;
	tput setaf 9;

	read -n1 klawisz;

	if [ "$klawisz" == "r" ]
    then
        start=${1:-"start"}
        jumpto $start
	else
		stty echo
		exit;
	fi
}

uaktualnij()
{
	for((i=1;i<=$W;i++))
	do
		if [ "${komin[$[$[i*K] + 1]]}" == "G" ]
		then
			for((e=1;e<=22;e++))
			do
				for((z=1;z<=5;z++))
				do
					komin[$[e*K]+$z]="";
					tput setab ${kolor_tla[$[$[e*K]+z]]};
					tput setaf ${kolor_znaku[$[$[e*K]+z]]};
					tput cup $e $z;
					
					if [ "${tablica[$[e*K+z]]}" == "p" ]
					then
						echo -n " "
					elif [ "${tablica[$[e*K+z]]}" == "k" ]
					then
						echo -n "*"
					else
						echo -n ${tablica[$[e*K+z]]}
					fi
				done
			done
		fi
		
		for((j=1;j<=$[K-4];j++))
		do
            if [ "${komin[$[i*K]+$j]}" == "G1" ]
            then
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
                        echo -n ${tablica[$[e*K+z]]}
                fi
            fi

            #zmiana koloru karty do głosowania jeżeli napotka ją ślina
            if [ "${slina[$[i*K]+$j]}" == "D" ]
            then
                if [ "${komin[$[i*K]+$j]}" == "G" ]
                then
                    slina[$[i*K]+$j]="";
                    
                    for((e=$[$i-1];e<=$[$i+1];e++))
                    do
                        for((z=$[$j-1];z<=$[$j+4];z++))
                        do
                            if [ "${komin[$[e*K]+$z]}" == "G" ]
                            then
                                komin[$[e*K]+$z]="G1";
                                tput setab 6;
                                tput setaf 6;
                                tput cup $e $z;
                                                                                                                            
                                echo -n " "
                            fi
                        done
                    done
                fi
            fi

            if [ "${komin[$[i*K]+$j]}" == "G" ]
			then
				komin[$[i*K]+$[j+3]]="";
				komin[$[i*K]+$[j-1]]="G";
				
				l=$[j+3];
				tput setab ${kolor_tla[$[$[i*K]+l]]};
				tput setaf ${kolor_znaku[$[$[i*K]+l]]};
				tput cup $i $l;
				
				if [ "${tablica[$[i*K+l]]}" == "p" ]
				then
					echo -n " "
				elif [ "${tablica[$[i*K+l]]}" == "k" ]
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
					j=$[j+3];
                fi
            fi
            
            #Sprawdzanie czy pocisk zderzył sie z tencza:
            if [ "${slina[$[i*K]+$j]}" == "D" ]
            then
				if [ "${komin[$[i*K]+$j]}" == "K" ]
				then
					slina[$[i*K]+$j]="";
					for((e=$[$i-5];e<$[$i+4];e++))
					do
						for((z=$[$j-1];z<=$[$j+5];z++))
						do

						if [ "${komin[$[e*K]+$z]}" == "K" ]
						then
						    komin[$[e*K]+$z]="";
					    	tput setab ${kolor_tla[$[$[e*K]+z]]};
					    	tput setaf ${kolor_znaku[$[$[e*K]+z]]};
					    	tput cup $e $z;
						
					    	if [ "${tablica[$[e*K+z]]}" == "p" ]
				    		then
				    			echo -n " "
				    		elif [ "${tablica[$[e*K+z]]}" == "k" ]
				    		then
				    			echo -n "*"
				    		else
					    		echo -n ${tablica[$[e*K+z]]}
					    	fi
					    fi
						done
					done    
				fi
            fi

			if [ "${komin[$[i*K]+$j]}" == "K" ]
			then
				tak=1;
				
				if [ $H -eq 0 ]
				then
					H=$CO_ILE;
					X=$[RANDOM%2];
					PP=$[last_up + 9];
					QQ=$[last_down + 9];
					
					if [ $X -eq 0 ]
					then
						WYSOKOSC_DOLNEGO=$[27-PP];
						WYSOKOSC_GORNEGO=$[27-WYSOKOSC_DOLNEGO-9];
						
					else
						WYSOKOSC_GORNEGO=$[27-QQ];
						WYSOKOSC_DOLNEGO=$[27-WYSOKOSC_GORNEGO-9];
					fi
					
					last_up=$[WYSOKOSC_GORNEGO+1];
					last_down=$[WYSOKOSC_DOLNEGO+1];
					
					rysuj_komindolny $last_down;
					rysuj_komingorny $last_up;
					
					Z=$[RANDOM%16 + 4];
					rysuj_glos $Z;
					
					wyswietl_komin;
				fi
				
				if [ $last_up -eq 0 ]
				then
					last_up=2;
					lastdown=$[last_down-2];
				fi
				
				if [ $last_down -eq 0 ]
				then
					last_down=2;
					last_up=$[last_up-2];
				fi
				
				komin[$[i*K]+$[j+4]]="";
				komin[$[i*K]+$[j-1]]="K";
				l=$[j+4];
				tput setab ${kolor_tla[$[$[i*K]+l]]};
				tput setaf ${kolor_znaku[$[$[i*K]+l]]};
				tput cup $i $l;
				
				if [ "${tablica[$[i*K+l]]}" == "p" ]
				then
					echo -n " "
				elif [ "${tablica[$[i*K+l]]}" == "k" ]
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
					j=$[j+4];
                fi
				
				if [ $j -lt 5 ]
				then
					for((e=1;e<=22;e++))
					do
						for((z=1;z<=5;z++))
						do
							komin[$[e*K]+$z]="";
							tput setab ${kolor_tla[$[$[e*K]+z]]};
							tput setaf ${kolor_znaku[$[$[e*K]+z]]};
							tput cup $e $z;
							
							if [ "${tablica[$[e*K+z]]}" == "p" ]
							then
								echo -n " "
							elif [ "${tablica[$[e*K+z]]}" == "k" ]
							then
								echo -n "*"
							else
								echo -n ${tablica[$[e*K+z]]}
							fi
						done
					done
				fi 
			fi
            
            #Przedluzamy tor pocisku:
			if [ "${slina[$[i*K]+$j]}" == "D" ]
			then
                slina[$[i*K]+$[j]]="";
                
                if [ $j -le 75 ]
                then
                    slina[$[i*K]+$[j+1]]="D";
                fi

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

                if [ $j -le 75 ]
                then        
                    tput setab 7;
                    tput setaf 7;
                    tput cup $i $[j+1]
                    echo -n " "
                fi  
			fi
		done
	done
}

#program glowny
start:
wyczysc;
stty -echo
welcome;
rysowanie_planszy;
rysuj_postac_kucajaca $y;
jaka=1;
min=14;
max=21;

wys_komina=9;
rysuj_komindolny $wys_komina;
rysuj_komingorny 4;
wyswietl_komin;
co=0;

while : 
do
	sprawdz_czy_punkt;
	sprawdz_czy_zabity;
		
	if [ $co -eq 0 ]
	then
		co=1;
		wypis_wyniku;
		tput cup 22 82;
		
		read -t 0.01 -rsn1 -d '' PRESS
		
		last=$y;
		
		case "$PRESS" in
			w) y=$[y-1] ;; # Up
			s) y=$[y+1] ;; # Down
            d) pluj $y ;; 
			1) gameover;
		esac
		
		sprawdz_czy_punkt;
		sprawdz_czy_zabity;
		
		k=$[last-y];
	else
		co=0
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
		
		if [ $k -ne 0 ]
		then
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
		fi
		
		uaktualnij;
		H=$[H-1];
	fi
done
stty echo
#kontrolny_wypis_tablicy_zgodny_z_kolorami;

#Rafał Byczek
#Dawid  Rączka
