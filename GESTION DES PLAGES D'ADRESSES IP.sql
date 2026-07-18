/***************************************************************************************************
* PROJET : GESTION DES PLAGES D'ADRESSES IP
* SGBD   : PostgreSQL 13+
* Auteur : MUHINDO KISUMBA ABDIEL
* Description :
*   - Gestion des plages IPv4
*   - Calcul automatique du nombre d'adresses
*   - Vérification de cohérence
*   - Recherche d'une IP dans une plage
***************************************************************************************************/

------------------------------------------------------------
-- SUPPRESSION
------------------------------------------------------------

DROP TABLE IF EXISTS plage_ip CASCADE;

------------------------------------------------------------
-- TABLE DES PLAGES IP
------------------------------------------------------------

CREATE TABLE plage_ip
(
    id_plage           SERIAL PRIMARY KEY,

    nom_plage          VARCHAR(100) NOT NULL,

    adresse_debut      INET NOT NULL,

    adresse_fin        INET NOT NULL,

    masque             SMALLINT NOT NULL
                        CHECK (masque BETWEEN 0 AND 32),

    passerelle         INET,

    dns_primaire       INET,

    dns_secondaire     INET,

    vlan               INTEGER,

    localisation       VARCHAR(150),

    service            VARCHAR(150),

    commentaire        TEXT,

    active             BOOLEAN DEFAULT TRUE,

    date_creation      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_plage
        CHECK (adresse_debut <= adresse_fin)
);

------------------------------------------------------------
-- INDEX
------------------------------------------------------------

CREATE INDEX idx_ip_debut
ON plage_ip(adresse_debut);

CREATE INDEX idx_ip_fin
ON plage_ip(adresse_fin);

CREATE INDEX idx_service
ON plage_ip(service);

------------------------------------------------------------
-- DONNEES D'ESSAI
------------------------------------------------------------

INSERT INTO plage_ip
(
    nom_plage,
    adresse_debut,
    adresse_fin,
    masque,
    passerelle,
    dns_primaire,
    dns_secondaire,
    vlan,
    localisation,
    service,
    commentaire
)
VALUES

('Administration',
 '192.168.1.1',
 '192.168.1.254',
 24,
 '192.168.1.1',
 '8.8.8.8',
 '1.1.1.1',
 10,
 'Siège',
 'Administration',
 'Réseau administratif'),

('Finance',
 '192.168.2.1',
 '192.168.2.254',
 24,
 '192.168.2.1',
 '8.8.8.8',
 '1.1.1.1',
 20,
 'Siège',
 'Finance',
 'Comptabilité'),

('RH',
 '192.168.3.1',
 '192.168.3.254',
 24,
 '192.168.3.1',
 '8.8.8.8',
 '1.1.1.1',
 30,
 'Siège',
 'Ressources Humaines',
 'Personnel'),

('Serveurs',
 '10.0.0.1',
 '10.0.0.254',
 24,
 '10.0.0.1',
 '8.8.8.8',
 '1.1.1.1',
 100,
 'Datacenter',
 'Infrastructure',
 'Serveurs'),

('Invités',
 '172.16.0.1',
 '172.16.0.254',
 24,
 '172.16.0.1',
 '8.8.8.8',
 '1.1.1.1',
 200,
 'Hall',
 'WiFi Invités',
 'Accès Internet'),

('Caméras IP',
 '192.168.50.1',
 '192.168.50.254',
 24,
 '192.168.50.1',
 '8.8.8.8',
 '1.1.1.1',
 50,
 'Tous bâtiments',
 'Vidéosurveillance',
 'Caméras'),

('Téléphones IP',
 '192.168.60.1',
 '192.168.60.254',
 24,
 '192.168.60.1',
 '8.8.8.8',
 '1.1.1.1',
 60,
 'Tous bâtiments',
 'VoIP',
 'Téléphonie');

------------------------------------------------------------
-- FONCTION : CONVERTIR IP EN BIGINT
------------------------------------------------------------

CREATE OR REPLACE FUNCTION ip_to_bigint(ip inet)
RETURNS bigint
LANGUAGE SQL
IMMUTABLE
AS
$$
SELECT
(split_part(host($1),'.',1)::bigint << 24)
+
(split_part(host($1),'.',2)::bigint << 16)
+
(split_part(host($1),'.',3)::bigint << 8)
+
(split_part(host($1),'.',4)::bigint);
$$;

------------------------------------------------------------
-- VUE : CALCUL DU NOMBRE D'IP
------------------------------------------------------------

CREATE OR REPLACE VIEW vw_plage_ip AS

SELECT

id_plage,

nom_plage,

adresse_debut,

adresse_fin,

masque,

passerelle,

dns_primaire,

dns_secondaire,

vlan,

service,

localisation,

active,

(ip_to_bigint(adresse_fin)
-
ip_to_bigint(adresse_debut)
+1) AS nombre_adresses

FROM plage_ip;

------------------------------------------------------------
-- RECHERCHE D'UNE IP DANS UNE PLAGE
------------------------------------------------------------

SELECT *
FROM plage_ip
WHERE '192.168.2.45'::inet
BETWEEN adresse_debut AND adresse_fin;

------------------------------------------------------------
-- LISTE COMPLETE
------------------------------------------------------------

SELECT *
FROM vw_plage_ip
ORDER BY adresse_debut;

------------------------------------------------------------
-- RECHERCHE PAR VLAN
------------------------------------------------------------

SELECT *
FROM plage_ip
WHERE vlan = 20;

------------------------------------------------------------
-- RECHERCHE PAR SERVICE
------------------------------------------------------------

SELECT *
FROM plage_ip
WHERE service ILIKE '%Administration%';

------------------------------------------------------------
-- NOMBRE TOTAL D'ADRESSES PAR SERVICE
------------------------------------------------------------

SELECT

service,

SUM(
ip_to_bigint(adresse_fin)
-
ip_to_bigint(adresse_debut)
+1
) AS total_ip

FROM plage_ip

GROUP BY service

ORDER BY total_ip DESC;

------------------------------------------------------------
-- PLAGES ACTIVES
------------------------------------------------------------

SELECT *
FROM plage_ip
WHERE active = TRUE;

------------------------------------------------------------
-- MISE A JOUR
------------------------------------------------------------

UPDATE plage_ip
SET commentaire='Réseau sécurisé'
WHERE nom_plage='Administration';

------------------------------------------------------------
-- DESACTIVATION
------------------------------------------------------------

UPDATE plage_ip
SET active=FALSE
WHERE nom_plage='Invités';

------------------------------------------------------------
-- SUPPRESSION (EXEMPLE)
------------------------------------------------------------

-- DELETE FROM plage_ip
-- WHERE id_plage=1;

------------------------------------------------------------
-- STATISTIQUES
------------------------------------------------------------

SELECT

COUNT(*)                    AS nombre_plages,

SUM(
ip_to_bigint(adresse_fin)
-
ip_to_bigint(adresse_debut)
+1
)                           AS total_adresses,

MIN(adresse_debut)          AS premiere_ip,

MAX(adresse_fin)            AS derniere_ip

FROM plage_ip;