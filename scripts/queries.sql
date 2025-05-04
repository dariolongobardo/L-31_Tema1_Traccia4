
-- 1. Recupero dei biglietti disponibili per una tratta in una certa data
SELECT 
	t.codice_treno, stp.nome, tt.data as data_partenza,tr.ora_partenza, sta.nome, tr.ora_arrivo, tr.distanza_km,
   	t.numero_posti - COUNT(sv.id) AS posti_disponibili
FROM Treno_Tratta tt
	JOIN Treno t ON t.id = tt.id_treno
	JOIN Tratta tr ON tr.id = tt.id_tratta
	JOIN stazione stp on tr.id_stazione_partenza = stp.id and stp.id = 6
	JOIN stazione sta on tr.id_stazione_arrivo = sta.id and sta.id = 7
	LEFT JOIN SEGMENTO_VIAGGIO sv ON sv.id_treno_tratta = tt.id
WHERE 
	tt.data = '2025-05-10'
GROUP BY 
	t.codice_treno, stp.nome, tt.data, tr.ora_partenza, sta.nome, tr.ora_arrivo, tr.distanza_km, t.numero_posti
HAVING 
	T.numero_posti - count(sv.id) > 0
;


-- 2. Query per recuperare tutte le informazioni relative ad una prenotazione per un utente
SELECT
    pr.id as id_prenotazione,pr.stato as st_prenotazione, p.nome, p.cognome, p.email, b.codice_biglietto as cd_biglietto,
    b.data_viaggio as dt_viaggio, b.validato, r.id as id_rimborso, r.stato AS st_rimborso, 
    r.data_richiesta as dt_richiesta, r.importo, stp.nome as staz_arr, sta.nome as staz_part, t.ora_partenza, t.ora_arrivo,
    tr.codice_treno as cd_treno
FROM prenotazione pr
	JOIN passeggero p ON pr.id_passeggero = p.id
	LEFT JOIN biglietto b ON b.id_prenotazione  = pr.id
	LEFT JOIN rimborso r ON r.id_biglietto = b.id
	LEFT JOIN segmento_viaggio sv ON sv.id_biglietto = b.id
	LEFT JOIN treno_tratta tt ON sv.id_treno_tratta = tt.id
	LEFT JOIN tratta t ON tt.id_tratta = t.id
	LEFT JOIN stazione stp on t.id_stazione_partenza = stp.id 
	LEFT JOIN stazione sta on t.id_stazione_arrivo = sta.id
	LEFT JOIN treno tr ON tt.id_treno = tr.id
WHERE 
	LOWER(p.cognome) = LOWER('Rossi') 
	AND pr.id = 5 /* COMMENTARE (O RIMUOVERE) QUESTA CONDIZIONE PER AVERE I DETTAGLI DI TUTTE LE PRENOTAZIONI PER L'UTENTE */
ORDER BY 
	B.DATA_VIAGGIO desc
;


-- 3. Query per controllare la validità di un biglietto.
SELECT 
	b.id, p.nome, p.cognome, b.data_viaggio, b.validato
FROM biglietto b
	JOIN prenotazione pr ON b.id_prenotazione = pr.id
	JOIN passeggero p ON pr.id_passeggero = p.id
WHERE pr.stato = 'confermata' and (b.validato = false or b.validato is null)
	and not exists(select 1 from rimborso r where r.id_biglietto = b.id and r.stato <> 'rifiutato')
;


-- 4. Query per le statistiche sulle tratte più frequentate
SELECT 
	tr.id AS tratta_id, s1.nome AS partenza, s2.nome AS arrivo, count(*) AS utilizzi
FROM segmento_viaggio sv
	JOIN Treno_Tratta tt ON sv.id_treno_tratta = tt.id
	JOIN Tratta tr ON tt.id_tratta = tr.id
	JOIN Stazione s1 ON tr.id_stazione_partenza = s1.id
	JOIN Stazione s2 ON tr.id_stazione_arrivo = s2.id
where tt.data between '2025-05-10' and '2025-10-11'
GROUP BY tr.id, s1.nome, s2.nome
ORDER BY utilizzi desc
;


-- 5. Query per il recupero di tutte le richieste di rimborso in attesa
SELECT r.id as id_rimborso, b.codice_biglietto, r.data_richiesta, r.importo, r.stato
FROM Rimborso r
JOIN Biglietto b ON b.id = r.id_biglietto
WHERE r.stato = 'in attesa'
;




