#include <stdio.h>
#include <stdlib.h>

#define MAX_PRODUCTS 10
#define MAX_SLOTS 100

// Dati dei prodotti
int identificativi[MAX_PRODUCTS];
int durate[MAX_PRODUCTS];
int scadenze[MAX_PRODUCTS];
int priorita[MAX_PRODUCTS];

void print_message(const char *message) {
    printf("%s", message);
}

void read_products() {
    int i;
    for (i = 0; i < MAX_PRODUCTS; i++) {
        printf("Inserisci i dati per il prodotto %d (identificativo durata scadenza priorità):\n", i + 1);
        scanf("%d %d %d %d", &identificativi[i], &durate[i], &scadenze[i], &priorita[i]);
    }
}

void sort_by_deadline(int count) {
    int i, j;
    for (i = 0; i < count - 1; i++) {
        for (j = 0; j < count - i - 1; j++) {
            if (scadenze[j] > scadenze[j + 1]) {
                // Scambio dei dati
                int temp_id = identificativi[j];
                int temp_dur = durate[j];
                int temp_scad = scadenze[j];
                int temp_prio = priorita[j];
                
                identificativi[j] = identificativi[j + 1];
                durate[j] = durate[j + 1];
                scadenze[j] = scadenze[j + 1];
                priorita[j] = priorita[j + 1];
                
                identificativi[j + 1] = temp_id;
                durate[j + 1] = temp_dur;
                scadenze[j + 1] = temp_scad;
                priorita[j + 1] = temp_prio;
            }
        }
    }
}

void sort_by_priority(int count) {
    int i, j;
    for (i = 0; i < count - 1; i++) {
        for (j = 0; j < count - i - 1; j++) {
            if (priorita[j] < priorita[j + 1]) {
                // Scambio dei dati
                int temp_id = identificativi[j];
                int temp_dur = durate[j];
                int temp_scad = scadenze[j];
                int temp_prio = priorita[j];
                
                identificativi[j] = identificativi[j + 1];
                durate[j] = durate[j + 1];
                scadenze[j] = scadenze[j + 1];
                priorita[j] = priorita[j + 1];
                
                identificativi[j + 1] = temp_id;
                durate[j + 1] = temp_dur;
                scadenze[j + 1] = temp_scad;
                priorita[j + 1] = temp_prio;
            }
        }
    }
}

void edf_scheduler(int count) {
    int time = 0;
    int i;
    int penalty = 0;

    for (i = 0; i < count; i++) {
        if (time + durate[i] > scadenze[i]) {
            penalty += (time + durate[i] - scadenze[i]) * priorita[i];
        }
        time += durate[i];
        printf("Produzione del prodotto %d terminata al tempo %d\n", identificativi[i], time);
    }
    printf("Penalità totale: %d\n", penalty);
}

void hpf_scheduler(int count) {
    int time = 0;
    int i;
    int penalty = 0;

    for (i = 0; i < count; i++) {
        if (time + durate[i] > scadenze[i]) {
            penalty += (time + durate[i] - scadenze[i]) * priorita[i];
        }
        time += durate[i];
        printf("Produzione del prodotto %d terminata al tempo %d\n", identificativi[i], time);
    }
    printf("Penalità totale: %d\n", penalty);
}

int main() {
    int choice, count;

    print_message("Seleziona un algoritmo, o esci:\n1) EDF\n2) HPF\n3) Esci\n");
    scanf("%d", &choice);

    if (choice == 1 || choice == 2) {
        print_message("Inserisci il numero di prodotti (max 10):\n");
        scanf("%d", &count);
        if (count > MAX_PRODUCTS) count = MAX_PRODUCTS;

        read_products();

        if (choice == 1) {
            sort_by_deadline(count);
            edf_scheduler(count);
        } else if (choice == 2) {
            sort_by_priority(count);
            hpf_scheduler(count);
        }
    } else {
        print_message("Opzione non valida.\n");
    }

    return 0;
}
