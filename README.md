# Pianificatore di Attività (Assembly x86)

Progetto realizzato per il corso di Laboratorio di Architettura degli Elaboratori[cite: 4]. 
Si tratta di un software scritto in linguaggio Assembly per la pianificazione dei lavori di un sistema di produzione[cite: 4].

## Specifiche del Progetto

Il programma legge da un file di input un massimo di 10 prodotti da lavorare nelle successive 100 unità temporali (elaborando un prodotto per unità di tempo)[cite: 4].
Ogni prodotto è definito da 4 parametri interi[cite: 4]:
- **ID:** Codice identificativo compreso tra 1 e 127[cite: 4].
- **Durata:** Tempo richiesto per la produzione, da 1 a 10[cite: 4].
- **Scadenza (Deadline):** Tempo limite entro il quale deve finire la produzione, da 1 a 100[cite: 4].
- **Priorità:** Indicatore di priorità, da 1 a 5[cite: 4].

In caso la produzione superi la scadenza prevista, il programma calcola una penalità utilizzando la seguente formula: `Penalità = Ritardo * priorità`[cite: 4].

## Algoritmi di Schedulazione

All'avvio, il programma presenta un menu che richiede input da tastiera (scelte 1, 2 o 3) per l'algoritmo da utilizzare o per chiudere il programma[cite: 4]:
- **1. EDF (Earliest Deadline First):** Ordina i prodotti confrontando le scadenze[cite: 4]. A parità di scadenza, valuta le priorità più alte per stabilire l'ordine[cite: 4].
- **2. HPF (Highest Priority First):** Ordina i prodotti in modo decrescente basandosi sul valore della priorità[cite: 4].

## Architettura e Moduli

Il codice è modulare e organizzato nei seguenti file e funzioni[cite: 4]:
- **pianificatore.s:** File principale contenente lo `start`[cite: 4]. Gestisce l'apertura del file di input e output tramite `syscall 5`, salvando il file descriptor e controllando eventuali errori di apertura[cite: 4]. Gestisce inoltre la stampa del menu e la lettura dell'input utente[cite: 4].
- **Lettura e Parsing:** Il file di testo viene letto byte per byte in un loop (grazie al ripristino di `lseek` con `syscall 19`)[cite: 4]. Al rilevamento di virgole o newline, la stringa letta viene convertita in intero tramite la funzione `atoi` e i valori vengono salvati nello stack[cite: 4]. Durante la lettura vengono eseguiti controlli di integrità per verificare che i dati rispettino le specifiche (es. massimo 10 prodotti)[cite: 4].
- **Logica di Ordinamento:** Le funzioni EDF e HPF operano direttamente all'interno dello stack, utilizzando i registri per spostarsi tra le colonne dei valori, confrontarli e scambiare le righe finché lo stack non risulta completamente ordinato[cite: 4].
- **task.s:** Modulo dedicato all'esecuzione simulata e alla formattazione dell'output (formato `ID: INIZIO`)[cite: 4]. Utilizza il registro `%ecx` come "orologio" per tenere traccia del tempo trascorso, somma la durata di ogni prodotto, calcola l'eventuale ritardo confrontandolo con la scadenza e aggiorna la penalità totale[cite: 4].
- **PrintInt / atoi:** Funzioni di supporto per convertire stringhe in interi in fase di lettura e interi in stringhe per la stampa a video o su file[cite: 4].

## Test

All'interno della directory `ordini` sono inclusi dei file di input per testare il comportamento degli algoritmi[cite: 4]:
- `HPF.txt`: Strutturato per restituire una penalità pari a 0 se testato con l'algoritmo HPF[cite: 4].
- `EDF.txt`: Strutturato per restituire una penalità pari a 0 se testato con l'algoritmo EDF[cite: 4].
- `None.txt`: Restituisce penalità 0 con entrambi gli algoritmi[cite: 4].
