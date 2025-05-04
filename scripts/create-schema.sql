
-- ==============================================
-- CREAZIONE SCHEMA DATABASE PER GESTIONE BIGLIETTI FERROVIARI
-- ==============================================

-- Elimina tutte le tabelle esistenti (se presenti)
DROP TABLE IF EXISTS RIMBORSO, MODIFICA_BIGLIETTO, SEGMENTO_VIAGGIO, BIGLIETTO, PRENOTAZIONE,
PASSEGGERO, TRENO_TRATTA, TRENO, TRATTA, STAZIONE CASCADE;

-- ==============================
-- TABELLA STAZIONE
-- ==============================
CREATE TABLE STAZIONE (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    citta VARCHAR(100) NOT NULL
);

-- ==============================
-- TABELLA TRATTA
-- ==============================
CREATE TABLE TRATTA (
    id SERIAL PRIMARY KEY,
    id_stazione_partenza INT NOT NULL,
    id_stazione_arrivo INT NOT NULL,
    ora_partenza TIME NOT NULL,
    ora_arrivo TIME NOT NULL,
    distanza_km INT NOT NULL,
    FOREIGN KEY (id_stazione_partenza) REFERENCES Stazione(id) ON DELETE CASCADE,
    FOREIGN KEY (id_stazione_arrivo) REFERENCES Stazione(id) ON DELETE CASCADE
);

-- ==============================
-- TABELLA TRENO
-- ==============================
CREATE TABLE TRENO (
    id SERIAL PRIMARY KEY,
    codice_treno VARCHAR(20) UNIQUE NOT NULL,
    numero_posti INT NOT NULL CHECK (numero_posti > 0)
);

-- ==============================
-- TABELLA TRENO_TRATTA
-- ==============================
CREATE TABLE TRENO_TRATTA (
    id SERIAL PRIMARY KEY,
    id_treno INT NOT NULL,
    id_tratta INT NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (id_treno) REFERENCES Treno(id) ON DELETE CASCADE,
    FOREIGN KEY (id_tratta) REFERENCES Tratta(id) ON DELETE CASCADE,
    UNIQUE (id_treno, id_tratta, data)
);

-- ==============================
-- TABELLA PASSEGGERO
-- ==============================
CREATE TABLE PASSEGGERO (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

-- ==============================
-- TABELLA PRENOTAZIONE
-- ==============================
CREATE TABLE PRENOTAZIONE (
    id SERIAL PRIMARY KEY,
    id_passeggero INT NOT NULL,
    data_prenotazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    stato VARCHAR(20) DEFAULT 'confermata' CHECK (stato IN ('confermata', 'cancellata', 'modificata')),
    FOREIGN KEY (id_passeggero) REFERENCES Passeggero(id) ON DELETE CASCADE
);

-- ==============================
-- TABELLA BIGLIETTO
-- ==============================
CREATE TABLE BIGLIETTO (
    id SERIAL PRIMARY KEY,
    id_prenotazione INT NOT NULL,
    codice_biglietto VARCHAR(30) UNIQUE NOT NULL,
    data_viaggio DATE NOT NULL,
    prezzo NUMERIC(6,2) NOT NULL CHECK (prezzo >= 0),
    validato BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_prenotazione) REFERENCES Prenotazione(id) ON DELETE CASCADE
);

-- ==============================
-- TABELLA SEGMENTO VIAGGIO
-- ==============================
CREATE TABLE SEGMENTO_VIAGGIO (
    id SERIAL PRIMARY KEY,
    id_biglietto INT NOT NULL,
    id_treno_tratta INT NOT NULL,
    ordine INT NOT NULL,
    FOREIGN KEY (id_biglietto) REFERENCES Biglietto(id) ON DELETE CASCADE,
    FOREIGN KEY (id_treno_tratta) REFERENCES Treno_Tratta(id) ON DELETE CASCADE
);

-- ==============================
-- TABELLA MODIFICHE BIGLIETTO
-- ==============================
CREATE TABLE MODIFICA_BIGLIETTO (
    id SERIAL PRIMARY KEY,
    id_biglietto INT NOT NULL,
    data_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivazione TEXT,
    FOREIGN KEY (id_biglietto) REFERENCES Biglietto(id) ON DELETE CASCADE
);

-- ==============================
-- TABELLA RIMBORSO
-- ==============================
CREATE TABLE RIMBORSO (
    id SERIAL PRIMARY KEY,
    id_biglietto INT NOT NULL,
    data_richiesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    stato VARCHAR(20) DEFAULT 'in attesa' CHECK (stato IN ('in attesa', 'approvato', 'rifiutato')),
    importo NUMERIC(6,2) CHECK (importo >= 0),
    FOREIGN KEY (id_biglietto) REFERENCES Biglietto(id) ON DELETE CASCADE
);

-- ==============================
-- INDICI AGGIUNTIVI PER OTTIMIZZAZIONE
-- ==============================
CREATE INDEX idx_stazione_nome ON STAZIONE(nome);
CREATE INDEX idx_tratta_stazioni ON TRATTA(id_stazione_partenza, id_stazione_arrivo);
CREATE INDEX idx_prenotazione_data ON PRENOTAZIONE(data_prenotazione);
CREATE INDEX idx_biglietto_data ON BIGLIETTO(data_viaggio);
CREATE INDEX idx_rimborso_stato ON RIMBORSO(stato);

