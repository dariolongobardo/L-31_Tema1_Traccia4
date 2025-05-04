# L-31_Tema1_Traccia4
Project Work Pegaso Tema 1 Traccia 4 di Dario Longobardo

## Progetto: Modello di Persistenza dei Dati per la Vendita di Biglietti Ferroviari

## Descrizione

Questo progetto consiste nella progettazione di un modello dati relazionale per supportare il processo di vendita, prenotazione, modifica e rimborso dei biglietti in un'azienda di trasporto ferroviario.
Il modello è stato sviluppato come parte di un elaborato accademico, utilizzando PostgreSQL come sistema di gestione database, Docker per l'ambiente di sviluppo, e DBeaver per la gestione grafica del database.


## Contenuto del Repository

- 📄 Script SQL per la creazione e gestione del database
- 🧩 Diagramma Entità-Relazione (ER)
- 📝 Documentazione delle entità e delle relazioni
- 🔍 Esempi di interrogazioni SQL (query di test funzionali)
- 🔄 Script di reset del database (reset-db.sql) per ricreare e popolare rapidamente il database con dati di esempio



## Tecnologie Utilizzate

- PostgreSQL (versione 14 o superiore)
- Docker (immagine ufficiale PostgreSQL)
- DBeaver (client grafico database)
- Visual Studio Code (editor SQL)
- Draw.io (Editor Schema E-R, Modello Relazionale)


## Avvio Rapido

### Prerequisiti
- Docker installato
- Accesso ad Internet (per scaricare l'immagine Docker se necessario)
### Avvio dell'istanza PostgreSQL su Docker
```bash
docker run --name progetto-biglietteria -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:latest
```
### Connessione al database (via DBeaver o altro client)
- Host: localhost
- Porta: 5432
- Database: postgres
- Username: postgres
- Password: postgres


## Istruzioni di Utilizzo

### Creazione del Database
1. Collegarsi all'istanza PostgreSQL con DBeaver o un altro client.
2. Eseguire lo script create-schema.sql per creare le tabelle e i vincoli.
3. (Opzionale) Eseguire lo script populate-sample-data.sql per inserire dati di esempio.
### Reset del Database
Per resettare il database in caso di test basta eseguire lo script: _**reset-db.sql**_


## Funzionalità Principali

- 📋 Gestione delle prenotazioni di biglietti ferroviari
- 🚆 Supporto ai viaggi con cambi su più tratte (_SEGMENTO_VIAGGIO_)
- 🔄 Gestione di modifiche e rimborsi dei biglietti
- 🔎 Query ottimizzate per la ricerca, validazione e analisi dei dati
- 🔒 Normalizzazione fino alla Terza Forma Normale (3NF)
- 📈 Raccolta dati per analisi statistiche sui viaggi


## Autore

Dario Longobardo

Elaborato realizzato per il corso di laurea in _L-31 Informatica per le Aziende digitali_, Anno Accademico 2024/2025.
