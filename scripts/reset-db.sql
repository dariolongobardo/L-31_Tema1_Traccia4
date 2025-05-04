
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

-- ==============================
-- INSERIMENTO DATI DI ESEMPIO
-- ==============================


INSERT INTO Stazione (nome, citta) VALUES 
('Venezia S. Lucia', 'Venezia'),
('Bari Centrale', 'Bari'),
('Firenze SMN', 'Firenze'),
('Bologna Centrale', 'Bologna'),
('Torino Porta Nuova', 'Torino'),
('Napoli Centrale', 'Napoli'), 
('Roma Termini', 'Roma'), 
('Milano Centrale', 'Milano');


INSERT INTO Tratta (id_stazione_partenza, id_stazione_arrivo, ora_partenza, ora_arrivo, distanza_km) VALUES 
(6, 7, '07:00', '10:00', 400),
(1, 8, '09:00', '13:00', 350),
(2, 4, '14:00', '15:30', 230),
(4, 5, '16:00', '17:00', 100),
(5, 6, '17:30', '19:30', 300),
(1, 2, '08:00', '10:00', 220), 
(2, 3, '10:30', '13:30', 570),
(6, 7, '15:00', '18:00', 400);

INSERT INTO Treno (codice_treno, numero_posti) VALUES 
('REG2024', 200),
('FR3040', 500),
('FR7722', 400),
('IC6543', 320),
('REG3210', 250),
('FR9810', 450), 
('IC7234', 300),
('TH1TR4', 5);

INSERT INTO Treno_Tratta (id_treno, id_tratta, data) VALUES 
(4, 6, '2025-05-11'),
(5, 7, '2025-05-11'),
(3, 3, '2025-05-10'),
(1, 4, '2025-05-10'),
(2, 5, '2025-05-10'),
(1, 1, '2025-05-10'), 
(2, 2, '2025-05-10'),
(8, 1, '2025-05-11'),
(8, 1, '2025-05-10'),
(8, 1, '2025-05-12'),
(8, 8, '2025-05-11'),
(8, 8, '2025-05-10'),
(8, 8, '2025-05-12');


INSERT INTO Passeggero (nome, cognome, email) VALUES 
('Alessandro', 'Neri', 'alessandro.neri@example.com'),
('Chiara', 'Mancini', 'chiara.mancini@example.com'),
('Simone', 'Ferri', 'simone.ferri@example.com'),
('Luisa', 'Verdi', 'luisa.verdi@example.com'),
('Giorgio', 'Bianchi', 'giorgio.bianchi@example.com'),
('Francesca', 'Russo', 'francesca.russo@example.com'),
('Mario', 'Rossi', 'mario.rossi@example.com'),
('Dario', 'Longobardo', 'dario.longobardo@example.com'),
('Lucia', 'Cimmino', 'lucia.cimmino@example.com'),
('Mario', 'Minopoli', 'mario.minopoli@example.com'),
('Luca', 'Sigismon', 'luca.sigismon@example.com'),
('Brunilde', 'Missori', 'bruni.miss@example.com'),
('Matilde', 'De Sica', 'matilde.desica@example.com'),
('Tina', 'Vespa', 'tina.vroom@example.com'),
('Guido', 'Gialli', 'guido.yellos@example.com');

INSERT INTO Prenotazione (id_passeggero) VALUES 
(5), (5), (6), (7), (7), (7), (2), 
(3), (4), (1), (8), (9), (10), (11), (12), (13), (14), (15);

INSERT INTO Biglietto (id_prenotazione, codice_biglietto, data_viaggio, prezzo, validato) VALUES 
(5, 'TK005-RMFI-01', '2025-05-11', 29.00, false),
(6, 'TK005-RMFI-02', '2025-05-11', 29.00, false),
(7, 'TK005-RMFI-03', '2025-05-11', 29.00, false),
(8, 'TK005-RMFI-04', '2025-05-11', 29.00, false),
(9, 'TK005-RMFI-05', '2025-05-11', 29.00, false),
(10, 'TK005-RMFI-06', '2025-05-11', 29.00, false),
(2, 'TK002-RMFI', '2025-05-10', 34.50, false),
(3, 'TK003-FIBO', '2025-05-10', 22.00, false),
(4, 'TK004-BOTO', '2025-05-10', 45.00, false),
(1, 'TK001-NRMIL', '2025-05-10', 59.99, false),
(11, 'TK006-NARO01', '2025-05-10', 30.00, true),
(12, 'TK006-NARO02', '2025-05-10', 30.00, true),
(13, 'TK006-NARO03', '2025-05-10', 30.00, true),
(14, 'TK006-NARO04', '2025-05-10', 30.00, true),
(15, 'TK006-NARO05', '2025-05-10', 30.00, true),
(16, 'TK006-NARO10', '2025-05-10', 33.00, true),
(17, 'TK006-NARO11', '2025-05-10', 33.00, true),
(18, 'TK006-NARO12', '2025-05-10', 33.00, true);

INSERT INTO Segmento_Viaggio (id_biglietto, id_treno_tratta, ordine) VALUES 
(5, 3, 1), (6, 3, 1), (7, 3, 1), (8, 3, 1), (9, 3, 1), 
(10, 3, 1), (2, 3, 1), (3, 4, 1), (4, 5, 1), (1, 1, 1), (1, 2, 2),
(11, 12, 1),(12, 12, 1),(13, 12, 1),(14, 12, 1),(15, 12, 1),
(16, 9, 1),(17, 9, 1),(18, 9, 1);

INSERT INTO Rimborso (id_biglietto, stato, importo) VALUES 
(5, 'approvato', 29.00),
(6, 'rifiutato', 29.00),
(7, 'approvato', 29.00),
(8, 'in attesa', 29.00),
(9, 'rifiutato', 29.00), 
(10, 'in attesa', 29.00),
(3, 'approvato', 22.00),
(4, 'rifiutato', 45.00),
(1, 'in attesa', 59.99);

INSERT INTO Modifica_Biglietto (id_biglietto, motivazione) VALUES 
(5, 'Modifica orario su richiesta del cliente'),
(6, 'Correzione dati passeggero'),
(8, 'Cambio tratta causa lavori sulla linea'),
(2, 'Aggiornamento orario partenza'),
(4, 'Cambio tratta su richiesta del cliente'),
(1, 'Cambio data per imprevisto');



