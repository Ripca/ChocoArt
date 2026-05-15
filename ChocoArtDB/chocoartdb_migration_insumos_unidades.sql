ALTER TABLE insumos
ADD unidad_compra VARCHAR(20) NOT NULL DEFAULT 'unidad',
ADD unidad_receta VARCHAR(20) NOT NULL DEFAULT 'unidad',
ADD rendimiento_por_compra DECIMAL(10,2) NOT NULL DEFAULT 1;

-- Migrar la unidad_medida actual a las nuevas columnas
UPDATE insumos 
SET unidad_compra = unidad_medida, 
    unidad_receta = unidad_medida;

-- Eliminar unidad_medida despues de migrar
ALTER TABLE insumos DROP COLUMN unidad_medida;
