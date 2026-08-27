# Pianificatore di Attività (Assembly x86)

Progetto realizzato per il corso di Laboratorio di Architettura degli Elaboratori.
Software scritto in linguaggio Assembly per la pianificazione automatizzata dei lavori di un sistema di produzione.

## Specifiche e Regole

Il programma legge da un file di input un massimo di 10 prodotti, schedulandoli per le successive 100 unità temporali (un prodotto per unità di tempo).
Ogni prodotto è definito da 4 parametri interi:
- **ID:** Identificativo univoco (1-127).
- **Durata:** Unità di tempo necessarie per la produzione (1-10).
- **Scadenza (Deadline):** Tempo limite di fine produzione (1-100).
- **Priorità:** Livello di urgenza (1-5).

In caso di ritardo, il programma calcola una penalità automatica: `Penalità = Ritardo * priorità`.

## Algoritmi di Schedulazione

All'avvio, un menu richiede all'utente quale logica di pianificazione applicare:
- **1. EDF (Earliest Deadline First):** Ordinamento basato sulle scadenze (deadline). In caso di parità, la precedenza viene stabilita valutando la priorità più alta.
- **2. HPF (Highest Priority First):** Ordinamento decrescente basato esclusivamente sul valore della priorità.

## Struttura del Codice

Il sistema è suddiviso in moduli per gestire input/output e logica di calcolo:
- **pianificatore.s:** Modulo principale. Gestisce l'apertura del file tramite `syscall 5`, salva il file descriptor, cattura gli errori di apertura, stampa il menu interattivo e legge l'input utente.
- **Lettura e Parsing:** Il file viene letto byte per byte (`syscall 19` per il ripristino del puntatore `lseek`). Le stringhe catturate vengono convertite in interi tramite una funzione `atoi` e memorizzate nello stack, controllando che non si superi il limite di 10 prodotti.
- **Ordinamento In-Place:** Le funzioni EDF e HPF operano direttamente all'interno dello stack, utilizzando i registri della CPU per confrontare le colonne dei parametri e scambiare le righe fino all'ordinamento completo.
- **task.s (Esecuzione):** Simula il tempo di elaborazione usando il registro `%ecx` come orologio interno. Calcola i tempi di inizio/fine, verifica eventuali sforamenti rispetto alla deadline e calcola la penalità cumulativa formattando l'output (`ID: INIZIO`).

## Testing

La cartella `ordini` contiene i file di testo per simulare diversi scenari operativi:
- `HPF.txt`: Genera penalità pari a 0 se eseguito con l'algoritmo HPF.
- `EDF.txt`: Genera penalità pari a 0 se eseguito con l'algoritmo EDF.
- `None.txt`: Restituisce penalità 0 con entrambi gli algoritmi.
