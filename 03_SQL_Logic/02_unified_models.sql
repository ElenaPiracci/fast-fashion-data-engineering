CREATE VIEW view_global_production AS
SELECT 'hm' AS source_brand, factory_id, product_id, production_volume, total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM hm_production_facts
UNION ALL
SELECT 'inditex', factory_id, product_id, production_volume,total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM inditex_production_facts
UNION ALL
SELECT 'primark', factory_id, product_id, production_volume,total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM primark_production_facts
UNION ALL
SELECT 'shein', factory_id, product_id, production_volume,total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM shein_production_facts
UNION ALL
SELECT 'sparc', factory_id, product_id, production_volume,total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM sparc_production_facts
UNION ALL
SELECT 'teddy', factory_id, product_id, production_volume,total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM teddy_production_facts
UNION ALL
SELECT 'uniqlo', factory_id, product_id, production_volume,total_water_footprint, total_carbon_footprint, waste_percentage, timestamp FROM uniqlo_production_facts;



CREATE OR REPLACE VIEW view_global_logistics AS
SELECT 
    'HM' AS brand, 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city AS destination_city, 
    d.latitude AS dest_latitude, 
    d.longitude AS dest_longitude, 
    fac.country_code AS origin_country,
    fac.factory_latitude AS origin_latitude, 
    fac.factory_longitude AS origin_longitude
FROM hm_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN hm_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN hm_dim_factories fac ON f.origin_factory_id = fac.factory_id

UNION ALL

SELECT 
    'Inditex', 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city, 
    d.latitude, 
    d.longitude, 
    fac.country_code,
    fac.factory_latitude, 
    fac.factory_longitude
FROM inditex_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN inditex_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN inditex_dim_factories fac ON f.origin_factory_id = fac.factory_id

UNION ALL

SELECT 
    'Primark', 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city, 
    d.latitude, 
    d.longitude, 
    fac.country_code,
    fac.factory_latitude, 
    fac.factory_longitude
FROM primark_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN primark_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN primark_dim_factories fac ON f.origin_factory_id = fac.factory_id

UNION ALL

SELECT 
    'Shein', 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city, 
    d.latitude, 
    d.longitude, 
    fac.country_code,
    fac.factory_latitude, 
    fac.factory_longitude
FROM shein_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN shein_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN shein_dim_factories fac ON f.origin_factory_id = fac.factory_id

UNION ALL

SELECT 
    'Sparc', 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city, 
    d.latitude, 
    d.longitude, 
    fac.country_code,
    fac.factory_latitude, 
    fac.factory_longitude
FROM sparc_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN sparc_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN sparc_dim_factories fac ON f.origin_factory_id = fac.factory_id

UNION ALL

SELECT 
    'Teddy', 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city, 
    d.latitude, 
    d.longitude, 
    fac.country_code,
    fac.factory_latitude, 
    fac.factory_longitude
FROM teddy_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN teddy_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN teddy_dim_factories fac ON f.origin_factory_id = fac.factory_id

UNION ALL

SELECT 
    'Uniqlo', 
    f.shipment_id, 
    f.transport_co2_footprint, 
    t.transport_name, 
    d.city, 
    d.latitude, 
    d.longitude, 
    fac.country_code,
    fac.factory_latitude, 
    fac.factory_longitude
FROM uniqlo_fact_logistics f 
LEFT JOIN dim_transport_modes t ON f.transport_id = t.transport_id 
LEFT JOIN uniqlo_dim_destinations d ON f.destination_id = d.destination_id 
LEFT JOIN uniqlo_dim_factories fac ON f.origin_factory_id = fac.factory_id;