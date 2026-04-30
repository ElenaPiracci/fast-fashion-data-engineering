CREATE OR REPLACE VIEW Vista_Classifica_Mensile_Sostenibilita AS
SELECT 
    Azienda,
    Anno,
    Mese,
    SUM(production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0) * 10) + 
        (SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0) / 10) +   
        AVG(waste_percentage) +                                                   
        (SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0) * 10)
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0) * 10) +
            (SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0) / 10) +
            AVG(waste_percentage) +
            (SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0) * 10) +
            (SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0) / 10) +
            AVG(waste_percentage) +
            (SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0) * 10) +
            (SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0) / 10) +
            AVG(waste_percentage) +
            (SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0) * 10) +
            (SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0) / 10) +
            AVG(waste_percentage) +
            (SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0) * 10) +
            (SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0) / 10) +
            AVG(waste_percentage) +
            (SUM(microplastic_shedding_rank * production_volume) / NULLIF(SUM(production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita

FROM (
    SELECT 'H&M Group' AS Azienda, YEAR(pf.timestamp) AS Anno, MONTH(pf.timestamp) AS Mese, pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM hm_production_facts pf JOIN hm_dim_products p ON pf.product_id = p.product_id JOIN hm_ref_materials rm ON p.main_material = rm.material_name
    UNION ALL
    SELECT 'Inditex' AS Azienda, YEAR(pf.timestamp), MONTH(pf.timestamp), pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM inditex_production_facts pf JOIN inditex_dim_products p ON pf.product_id = p.product_id JOIN inditex_ref_materials rm ON p.main_material = rm.material_name
    UNION ALL
    SELECT 'Uniqlo' AS Azienda, YEAR(pf.timestamp), MONTH(pf.timestamp), pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM uniqlo_production_facts pf JOIN uniqlo_dim_products p ON pf.product_id = p.product_id JOIN uniqlo_ref_materials rm ON p.main_material = rm.material_name
    UNION ALL
    SELECT 'Primark' AS Azienda, YEAR(pf.timestamp), MONTH(pf.timestamp), pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM primark_production_facts pf JOIN primark_dim_products p ON pf.product_id = p.product_id JOIN primark_ref_materials rm ON p.main_material = rm.material_name
    UNION ALL
    SELECT 'Shein' AS Azienda, YEAR(pf.timestamp), MONTH(pf.timestamp), pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM shein_production_facts pf JOIN shein_dim_products p ON pf.product_id = p.product_id JOIN shein_ref_materials rm ON p.main_material = rm.material_name
    UNION ALL
    SELECT 'Sparc' AS Azienda, YEAR(pf.timestamp), MONTH(pf.timestamp), pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM sparc_production_facts pf JOIN sparc_dim_products p ON pf.product_id = p.product_id JOIN sparc_ref_materials rm ON p.main_material = rm.material_name
    UNION ALL
    SELECT 'Teddy' AS Azienda, YEAR(pf.timestamp), MONTH(pf.timestamp), pf.production_volume, pf.total_carbon_footprint, pf.total_water_footprint, pf.waste_percentage, rm.microplastic_shedding_rank FROM teddy_production_facts pf JOIN teddy_dim_products p ON pf.product_id = p.product_id JOIN teddy_ref_materials rm ON p.main_material = rm.material_name
) AS Dati_Unificati
GROUP BY 
    Azienda, 
    Anno, 
    Mese;



CREATE OR REPLACE VIEW Vista_Sostenibilita_HM AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM hm_production_facts pf
JOIN hm_dim_products p ON pf.product_id = p.product_id
JOIN hm_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sostenibilita_INDITEX AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM inditex_production_facts pf
JOIN inditex_dim_products p ON pf.product_id = p.product_id
JOIN inditex_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sostenibilita_primark AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM primark_production_facts pf
JOIN primark_dim_products p ON pf.product_id = p.product_id
JOIN primark_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sostenibilita_shein AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM shein_production_facts pf
JOIN shein_dim_products p ON pf.product_id = p.product_id
JOIN shein_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sostenibilita_sparc AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    -- Punteggio di Inquinamento Globale
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM sparc_production_facts pf
JOIN sparc_dim_products p ON pf.product_id = p.product_id
JOIN sparc_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sostenibilita_teddy AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM teddy_production_facts pf
JOIN teddy_dim_products p ON pf.product_id = p.product_id
JOIN teddy_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sostenibilita_uniqlo AS
SELECT 
    YEAR(pf.timestamp) AS Anno,
    MONTH(pf.timestamp) AS Mese,
    SUM(pf.production_volume) AS Totale_Capi_Prodotti,
    ROUND(SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS CO2_Media_Kg_Per_Capo,
    ROUND(SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0), 2) AS Acqua_Media_L_Per_Capo,
    ROUND(AVG(pf.waste_percentage), 2) AS Scarto_Medio_Fabbrica_Perc,
    ROUND(SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0), 2) AS Indice_Microplastiche,
    ROUND(
        (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) + 
        (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +   
        AVG(pf.waste_percentage) +                                                   
        (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10) 
    , 2) AS Punteggio_Inquinamento,
    CASE 
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 50 THEN 'A 🏆'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 70 THEN 'B 🟢'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 90 THEN 'C 🟡'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 120 THEN 'D 🟠'
        WHEN (
            (SUM(pf.total_carbon_footprint) / NULLIF(SUM(pf.production_volume), 0) * 10) +
            (SUM(pf.total_water_footprint) / NULLIF(SUM(pf.production_volume), 0) / 10) +
            AVG(pf.waste_percentage) +
            (SUM(rm.microplastic_shedding_rank * pf.production_volume) / NULLIF(SUM(pf.production_volume), 0) * 10)
        ) <= 150 THEN 'E 🔴'
        ELSE 'F ☠️'
    END AS Voto_Sostenibilita
FROM uniqlo_production_facts pf
JOIN uniqlo_dim_products p ON pf.product_id = p.product_id
JOIN uniqlo_ref_materials rm ON p.main_material = rm.material_name
GROUP BY 
    YEAR(pf.timestamp), 
    MONTH(pf.timestamp);



CREATE OR REPLACE VIEW Vista_Sovrapproduzione_Globale AS
SELECT 'H&M Group' AS Azienda, p.product_id, p.category, COALESCE(prod.Totale,0) AS Capi_Prodotti, COALESCE(log.Totale,0) AS Capi_Spediti, (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) AS Capi_In_Eccesso
FROM hm_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM hm_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM hm_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0

UNION ALL
SELECT 'Inditex', p.product_id, p.category, COALESCE(prod.Totale,0), COALESCE(log.Totale,0), (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0))
FROM inditex_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM inditex_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM inditex_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0

UNION ALL
SELECT 'Primark', p.product_id, p.category, COALESCE(prod.Totale,0), COALESCE(log.Totale,0), (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0))
FROM primark_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM primark_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM primark_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0

UNION ALL
SELECT 'Shein', p.product_id, p.category, COALESCE(prod.Totale,0), COALESCE(log.Totale,0), (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0))
FROM shein_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM shein_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM shein_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0

UNION ALL
SELECT 'Sparc', p.product_id, p.category, COALESCE(prod.Totale,0), COALESCE(log.Totale,0), (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0))
FROM sparc_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM sparc_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM sparc_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0

UNION ALL
SELECT 'Teddy', p.product_id, p.category, COALESCE(prod.Totale,0), COALESCE(log.Totale,0), (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0))
FROM teddy_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM teddy_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM teddy_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0

UNION ALL
SELECT 'Uniqlo', p.product_id, p.category, COALESCE(prod.Totale,0), COALESCE(log.Totale,0), (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0))
FROM uniqlo_dim_products p 
LEFT JOIN (SELECT product_id, SUM(production_volume) AS Totale FROM uniqlo_production_facts GROUP BY product_id) prod ON p.product_id = prod.product_id 
LEFT JOIN (SELECT product_id, SUM(shipped_quantity) AS Totale FROM uniqlo_fact_logistics GROUP BY product_id) log ON p.product_id = log.product_id 
WHERE (COALESCE(prod.Totale,0) - COALESCE(log.Totale,0)) > 0;



CREATE OR REPLACE VIEW Tot_Capi_In_Eccesso as
SELECT 
    Azienda, 
    SUM(Capi_In_Eccesso) AS Totale_Capi_In_Eccesso,
    ROUND(SUM(Capi_In_Eccesso * CalcolaCarbonFootprintProdotto(Azienda, product_id)), 2) AS Totale_CO2_Sprecata_Kg,
    ROUND(SUM(Capi_In_Eccesso * CalcolaWaterFootprintProdotto(Azienda, product_id)), 2) AS Totale_Acqua_Sprecata_Litri
FROM Vista_Sovrapproduzione_Globale
GROUP BY Azienda
ORDER BY Totale_CO2_Sprecata_Kg DESC;



CREATE VIEW view_produzione_brand_per_inquinamento AS
SELECT 
    source_brand,
    SUM(production_volume) AS vol_totale,
    ROUND(SUM(total_carbon_footprint) / SUM(production_volume), 2) AS co2_per_capo,
    ROUND(SUM(total_water_footprint) / SUM(production_volume), 2) AS acqua_per_capo,
    AVG(waste_percentage) AS scarto_medio
FROM view_global_production
GROUP BY source_brand
ORDER BY co2_per_capo DESC;