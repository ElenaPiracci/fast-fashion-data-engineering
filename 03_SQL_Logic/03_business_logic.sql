DELIMITER //
DROP FUNCTION IF EXISTS CalcolaWaterFootprintProdotto; //
CREATE FUNCTION CalcolaWaterFootprintProdotto(
    p_company_name VARCHAR(100),
    p_product_id VARCHAR(50)
) 
RETURNS DECIMAL(15,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_water_per_unit DECIMAL(15,2) DEFAULT 0;

    IF p_company_name = 'H&M Group' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM hm_production_facts WHERE product_id = p_product_id;

    ELSEIF p_company_name = 'Inditex' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM inditex_production_facts WHERE product_id = p_product_id;

    ELSEIF p_company_name = 'Uniqlo' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM uniqlo_production_facts WHERE product_id = p_product_id;

    ELSEIF p_company_name = 'Primark' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM primark_production_facts WHERE product_id = p_product_id;

    ELSEIF p_company_name = 'Shein' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM shein_production_facts WHERE product_id = p_product_id;

    ELSEIF p_company_name = 'Sparc' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM sparc_production_facts WHERE product_id = p_product_id;

    ELSEIF p_company_name = 'Teddy' THEN
        SELECT COALESCE(SUM(total_water_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_water_per_unit FROM teddy_production_facts WHERE product_id = p_product_id;
    END IF;
    RETURN v_water_per_unit;
END //
DELIMITER ;



DELIMITER //
DROP FUNCTION IF EXISTS CalcolaCarbonFootprintProdotto; //
CREATE FUNCTION CalcolaCarbonFootprintProdotto(
    p_company_name VARCHAR(100),
    p_product_id VARCHAR(50)
) 
RETURNS DECIMAL(15,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_co2_per_unit DECIMAL(15,2) DEFAULT 0;
    IF p_company_name = 'H&M Group' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM hm_production_facts WHERE product_id = p_product_id;
    ELSEIF p_company_name = 'Inditex' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM inditex_production_facts WHERE product_id = p_product_id;
    ELSEIF p_company_name = 'Uniqlo' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM uniqlo_production_facts WHERE product_id = p_product_id;
    ELSEIF p_company_name = 'Primark' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM primark_production_facts WHERE product_id = p_product_id;
    ELSEIF p_company_name = 'Shein' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM shein_production_facts WHERE product_id = p_product_id;
    ELSEIF p_company_name = 'Sparc' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM sparc_production_facts WHERE product_id = p_product_id;
    ELSEIF p_company_name = 'Teddy' THEN
        SELECT COALESCE(SUM(total_carbon_footprint) / NULLIF(SUM(production_volume), 0), 0) 
        INTO v_co2_per_unit FROM teddy_production_facts WHERE product_id = p_product_id;
    END IF;
    RETURN v_co2_per_unit;
END //
DELIMITER ;



DELIMITER //
DROP FUNCTION IF EXISTS CalcolaMicroplasticheProdotto; //
CREATE FUNCTION CalcolaMicroplasticheProdotto(
    p_company_name VARCHAR(100),
    p_product_id VARCHAR(50)
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_microplastics_rank DECIMAL(10,2) DEFAULT 0;
    IF p_company_name = 'H&M Group' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM hm_dim_products p
        JOIN hm_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    ELSEIF p_company_name = 'Inditex' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM inditex_dim_products p
        JOIN inditex_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    ELSEIF p_company_name = 'Uniqlo' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM uniqlo_dim_products p
        JOIN uniqlo_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    ELSEIF p_company_name = 'Primark' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM primark_dim_products p
        JOIN primark_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    ELSEIF p_company_name = 'Shein' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM shein_dim_products p
        JOIN shein_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    ELSEIF p_company_name = 'Sparc' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM sparc_dim_products p
        JOIN sparc_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    ELSEIF p_company_name = 'Teddy' THEN
        SELECT COALESCE(MAX(rm.microplastic_shedding_rank), 0) INTO v_microplastics_rank
        FROM teddy_dim_products p
        JOIN teddy_ref_materials rm ON p.main_material = rm.material_name
        WHERE p.product_id = p_product_id;
    END IF;
    RETURN v_microplastics_rank;
END //
DELIMITER ;



DELIMITER //
DROP FUNCTION IF EXISTS CalcolaMoltiplicatoreTrasporto; //
CREATE FUNCTION CalcolaMoltiplicatoreTrasporto(
    p_transport_id VARCHAR(50)
) 
RETURNS DECIMAL(10,3)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_multiplier DECIMAL(10,3) DEFAULT 0.000;
    SELECT COALESCE(co2_per_ton_km, 0) 
    INTO v_multiplier
    FROM dim_transport_modes
    WHERE transport_id = p_transport_id;
    RETURN v_multiplier;
END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS CalcolaImpattoAziendale; //
CREATE PROCEDURE CalcolaImpattoAziendale(
    IN p_company_name VARCHAR(50),
    IN p_impact_type VARCHAR(50)
)
BEGIN
    DECLARE v_total_co2 DECIMAL(15,2) DEFAULT 0; 
    DECLARE v_total_water DECIMAL(15,2) DEFAULT 0;
    DECLARE v_microplastics_avg DECIMAL(10,2) DEFAULT 0;
    SET p_impact_type = UPPER(TRIM(p_impact_type));
    IF p_company_name = 'H&M Group' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
        SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM hm_production_facts; 
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM hm_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM hm_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM hm_production_facts pf
            JOIN hm_dim_products p ON pf.product_id = p.product_id
            JOIN hm_ref_materials rm ON p.main_material = rm.material_name;
        END IF;

    ELSEIF p_company_name = 'Inditex' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
            SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM inditex_production_facts;
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM inditex_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM inditex_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM inditex_production_facts pf
            JOIN inditex_dim_products p ON pf.product_id = p.product_id
            JOIN inditex_ref_materials rm ON p.main_material = rm.material_name;
        END IF;
 
    ELSEIF p_company_name = 'Uniqlo' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
            SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM uniqlo_production_facts;
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM uniqlo_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM uniqlo_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM uniqlo_production_facts pf
            JOIN uniqlo_dim_products p ON pf.product_id = p.product_id
            JOIN uniqlo_ref_materials rm ON p.main_material = rm.material_name;
        END IF;

    ELSEIF p_company_name = 'Primark' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
            SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM primark_production_facts;
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM primark_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM primark_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM primark_production_facts pf
            JOIN primark_dim_products p ON pf.product_id = p.product_id
            JOIN primark_ref_materials rm ON p.main_material = rm.material_name;
        END IF;

    ELSEIF p_company_name = 'Shein' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
            SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM shein_production_facts;
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM shein_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM shein_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM shein_production_facts pf
            JOIN shein_dim_products p ON pf.product_id = p.product_id
            JOIN shein_ref_materials rm ON p.main_material = rm.material_name;
        END IF;
    -- 6. SPARC
    ELSEIF p_company_name = 'Sparc' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
            SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM sparc_production_facts;
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM sparc_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM sparc_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM sparc_production_facts pf
            JOIN sparc_dim_products p ON pf.product_id = p.product_id
            JOIN sparc_ref_materials rm ON p.main_material = rm.material_name;
        END IF;

    ELSEIF p_company_name = 'Teddy' THEN
        IF p_impact_type IN ('CO2', 'ALL') THEN
            SELECT COALESCE(SUM(total_carbon_footprint), 0) INTO v_total_co2 FROM teddy_production_facts;
            SELECT v_total_co2 + COALESCE(SUM(transport_co2_footprint), 0) INTO v_total_co2 FROM teddy_fact_logistics;
        END IF;
        IF p_impact_type IN ('WATER', 'ALL') THEN
            SELECT COALESCE(SUM(total_water_footprint), 0) INTO v_total_water FROM teddy_production_facts;
        END IF;
        IF p_impact_type IN ('MICROPLASTICS', 'ALL') THEN
            SELECT COALESCE(SUM(rm.microplastic_shedding_rank * pf.production_volume) / SUM(pf.production_volume), 0) 
            INTO v_microplastics_avg
            FROM teddy_production_facts pf
            JOIN teddy_dim_products p ON pf.product_id = p.product_id
            JOIN teddy_ref_materials rm ON p.main_material = rm.material_name;
        END IF;
    END IF;

    IF p_impact_type = 'CO2' THEN
        SELECT p_company_name AS Azienda, v_total_co2 AS Totale_CO2_Kg;
    ELSEIF p_impact_type = 'WATER' THEN
        SELECT p_company_name AS Azienda, v_total_water AS Totale_Acqua_Litri;
    ELSEIF p_impact_type = 'MICROPLASTICS' THEN
        SELECT p_company_name AS Azienda, v_microplastics_avg AS Rilascio_Medio_Microplastiche;
    ELSEIF p_impact_type = 'ALL' THEN
        SELECT p_company_name AS Azienda, 
               v_total_co2 AS Totale_CO2_Kg,
               v_total_water AS Totale_Acqua_Litri,
               v_microplastics_avg AS Rilascio_Medio_Microplastiche;
    ELSE
        SELECT 'Errore: Parametro non valido.' AS Messaggio;
    END IF;
END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS report_sostenibilita_annuale; //
CREATE PROCEDURE report_sostenibilita_annuale(IN p_anno INT)
BEGIN
    WITH logistics_filtrata AS (
        SELECT 'H&M Group' AS brand_name, transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM hm_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM hm_production_facts WHERE YEAR(timestamp) = p_anno)
        
        UNION ALL
        SELECT 'Inditex', transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM inditex_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM inditex_production_facts WHERE YEAR(timestamp) = p_anno)
        
        UNION ALL
        SELECT 'Primark', transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM primark_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM primark_production_facts WHERE YEAR(timestamp) = p_anno)
        
        UNION ALL
        SELECT 'Shein', transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM shein_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM shein_production_facts WHERE YEAR(timestamp) = p_anno)
        
        UNION ALL
        SELECT 'Sparc', transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM sparc_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM sparc_production_facts WHERE YEAR(timestamp) = p_anno)
        
        UNION ALL
        SELECT 'Teddy', transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM teddy_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM teddy_production_facts WHERE YEAR(timestamp) = p_anno)
        
        UNION ALL
        SELECT 'Uniqlo', transport_id, distance_km, total_weight_tons, transport_co2_footprint, transport_nox_footprint, transport_sox_footprint 
        FROM uniqlo_fact_logistics 
        WHERE product_id IN (SELECT product_id FROM uniqlo_production_facts WHERE YEAR(timestamp) = p_anno)
    ),
    ranking_mezzi AS (
        SELECT 
            lf.brand_name, tm.transport_name, COUNT(*) as n_viaggi,
            ROW_NUMBER() OVER(PARTITION BY lf.brand_name ORDER BY COUNT(*) DESC) as rnk
        FROM logistics_filtrata lf
        JOIN dim_transport_modes tm ON lf.transport_id = tm.transport_id
        GROUP BY lf.brand_name, tm.transport_name
    )
    SELECT 
        lf.brand_name AS Azienda,
        p_anno AS anno_riferimento,
        rm.transport_name AS mezzo_piu_usato,
        ROUND(SUM(lf.transport_co2_footprint), 2) AS co2_totale_kg,
        ROUND(SUM(lf.transport_nox_footprint), 2) AS nox_totale_kg,
        ROUND(SUM(lf.transport_co2_footprint) / NULLIF(SUM(lf.total_weight_tons * lf.distance_km), 0), 4) AS indice_inquinamento_co2,
        ROUND(COUNT(CASE WHEN lf.transport_id = 'T_AIR' THEN 1 END) * 100.0 / COUNT(*), 1) AS perc_aereo
    FROM 
        logistics_filtrata lf
    JOIN 
        ranking_mezzi rm ON lf.brand_name = rm.brand_name AND rm.rnk = 1
    GROUP BY 
        lf.brand_name, rm.transport_name
    ORDER BY 
        indice_inquinamento_co2 ASC;
END //
DELIMITER ;