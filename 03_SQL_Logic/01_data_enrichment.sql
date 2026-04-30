ALTER TABLE hm_dim_products 
ADD COLUMN material_id VARCHAR(50); 

SET SQL_SAFE_UPDATES = 0;

UPDATE hm_dim_products
JOIN hm_ref_materials ON hm_dim_products.main_material = hm_ref_materials.material_name
SET hm_dim_products.material_id = hm_ref_materials.material_id;

SET SQL_SAFE_UPDATES = 1;

#questa parte di codice è stata ripetura per alterare le tabelle prese in considerazione di ogni brand che avevamo preso in analisi.