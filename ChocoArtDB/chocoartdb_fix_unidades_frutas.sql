USE `chocoartdb`;

-- Corrige las frutas para que se muestren como porciones en recetas.
-- Esto evita que "1" se lea como una fruta entera.
UPDATE `insumos`
SET `unidad_medida` = 'porcion'
WHERE `idInsumo` IN (1, 2, 3);
