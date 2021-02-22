# Prova finale di Reti Logiche - AA 2019-2020

### Descrizione generale
La specifica della Prova finale (Progetto di Reti Logiche) 2019 è ispirata al metodo di codifica a bassa dissipazione di potenza denominato “Working Zone”.
Il metodo di codifica Working Zone è un metodo pensato per il Bus Indirizzi che si usa per trasformare il valore di un indirizzo quando questo viene trasmesso, se appartiene a certi intervalli (detti appunto working-zone). Una working-zone è definita come un intervallo di indirizzi di dimensione fissa (Dwz) che parte da un indirizzo base. All’interno dello schema di codifica possono esistere multiple working-zone (Nwz).
Lo schema modificato di codifica da implementare è il seguente:
- se l’indirizzo da trasmettere (ADDR) non appartiene a nessuna Working Zone, esso viene trasmesso così come è, e un bit addizionale rispetto ai bit di indirizzamento (WZ_BIT) viene messo a 0. In pratica dato ADDR, verrà trasmesso WZ_BIT=0 concatenato ad ADDR (WZ_BIT & ADDR, dove & è il simbolo di concatenazione);
- se l’indirizzo da trasmettere (ADDR) appartiene ad una Working Zone, il bit addizionale WZ_BIT è posto a 1, mentre i bit di indirizzo vengono divisi in 2 sotto campi rappresentanti: il numero della working-zone al quale l’indirizzo appartiene WZ_NUM, che sarà codificato in binario; l’offset rispetto all’indirizzo di base della working zone WZ_OFFSET, codificato come one-hot (cioè il valore da rappresentare è equivalente all’unico bit a 1 della codifica).
In pratica dato ADDR, verrà trasmesso WZ_BIT=1 concatenato ad WZ_NUM e WZ_OFFSET ( WZ_BIT & WZ_NUM & WZ_OFFSET, dove & è il simbolo di concatenazione).

Nella versione da implementare il numero di bit da considerare per l’indirizzo da codificare è 7. Il che definisce come indirizzi validi quelli da 0 a 127. Il numero di working-zone è 8 (Nwz=8) mentre la dimensione della working-zone è 4 indirizzi incluso quello base (Dwz=4).
Questo comporta che l’indirizzo codificato sarà composto da 8 bit: 1 bit per WZ_BIT + 7 bit per ADDR, oppure 1 bit per WZ_BIT, 3 bit per codificare in binario a quale tra le 8 working zone l’indirizzo appartiene, e 4 bit per codificare one hot il valore dell’offset di ADDR rispetto all’indirizzo base.
Il modulo da implementare leggerà l’indirizzo da codificare e gli 8 indirizzi base delle working-zone e dovrà produrre l’indirizzo opportunamente codificato.

### Dati
I dati ciascuno di dimensione 8 bit sono memorizzati in una memoria con indirizzamento al Byte partendo dalla posizione 0. Anche l’indirizzo che è da specifica di 7 bit viene memorizzato su 8 bit. Il valore dell’ottavo bit sarà sempre zero.
Le posizioni in memoria da 0 a 7 sono usati per memorizzare gli otto indirizzi base delle working-zone:
- 0 - Indirizzo Base WZ 0
- 1 - Indirizzo Base WZ 1
- ...
- 7 - Indirizzo Base WZ 7

La posizione in memoria 8 avrà al suo interno il valore (indirizzo) da codificare (ADDR).
La posizione in memoria 9 è quella che deve essere usata per scrivere, alla fine, il valore codificato secondo le regole precedenti.

### Note ulteriori sulla specifica
Nella codifica 1 hot si consideri il bit 0 come il meno significativo. In pratica:
- WZ_OFFSET = 0 è codificato one hot come 0001;
- WZ_OFFSET = 1 è codificato one hot come 0010;
- WZ_OFFSET = 2 è codificato one hot come 0100;
- WZ_OFFSET = 3 è codificato one hot come 1000.

Riprendendo ancora la specifica, il valore codificato sarà così composto:
- Bit 7: valore del singolo bit di WZ_BIT; 
- Bit 6-4: valore codificato binario di WZ_NUM;
- Bit 3-0: valore codificato one-hot di WZ_OFFSET.

Se serve, si consideri che gli indirizzi base delle working-zone non cambieranno mai all’interno della stessa esecuzione.

Il modulo partirà nella elaborazione quando un segnale START in ingresso verrà portato a 1. Il segnale di START rimarrà alto fino a che il segnale di DONE non verrà portato alto; al termine della computazione (e una volta scritto il risultato in memoria), il modulo da progettare deve alzare (portare a 1) il segnale DONE che notifica la fine dell’elaborazione. Il segnale DONE deve rimanere alto fino a che il segnale di START non è riportato a 0. Un nuovo segnale start non può essere dato fin tanto che DONE non è stato riportato a zero. Se a questo punto viene rialzato il segnale di START, il modulo dovrà ripartire con la fase di codifica.

### Esempio
La seguente sequenza di numeri mostra un esempio del contenuto della memoria al termine di una elaborazione. I valori che qui sono rappresentati in decimale, sono memorizzati in memoria con l’equivalente codifica binaria su 8 bit senza segno.

CASO 1 CON VALORE NON PRESENTE IN NESSUNA WORKING-ZONE

|Indirizzo di memoria|Valore|Commento|
|--------------------|------|--------|
|0|4|Indirizzo Base WZ 0|
|1|13|Indirizzo Base WZ 1|
|2|22|Indirizzo Base WZ 2|
|3|31|Indirizzo Base WZ 3|
|4|37|Indirizzo Base WZ 4|
|5|45|Indirizzo Base WZ 5|
|6|77|Indirizzo Base WZ 6|
|7|91|Indirizzo Base WZ 7|
|8|42|ADDR da codificare|
|9|42|Valore codificato con in OUTPUT|

CASO 2 CON VALORE PRESENTE IN UNA WORKING-ZONE

|Indirizzo di memoria|Valore|Commento|
|--------------------|------|--------|
|0|4|Indirizzo Base WZ 0|
|1|13|Indirizzo Base WZ 1|
|2|22|Indirizzo Base WZ 2|
|3|31|Indirizzo Base WZ 3|
|4|37|Indirizzo Base WZ 4|
|5|45|Indirizzo Base WZ 5|
|6|77|Indirizzo Base WZ 6|
|7|91|Indirizzo Base WZ 7|
|8|33|ADDR da codificare|
|9|180|Valore codificato con in OUTPUT|
