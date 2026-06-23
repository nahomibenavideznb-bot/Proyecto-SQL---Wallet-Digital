SELECT *
FROM segmentacion_clientes;


SELECT*,
ROW_NUMBER() OVER(
PARTITION BY ï»¿ClienteID, Nombre, Edad, Segmento, Saldo, Producto, FechaRegistro, WalletActiva, Churn) AS row_num
FROM segmentacion_clientes;

WITH duplicate_cte AS
(
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY Nombre, Edad, Segmento, Saldo, Producto, FechaRegistro, WalletActiva, Churn) AS row_num
FROM segmentacion_clientes
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM segmentacion_clientes
WHERE Nombre = "Andrea Soto";

WITH duplicate_cte AS
(
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY Nombre, Edad, Segmento, Saldo, Producto, FechaRegistro, WalletActiva, Churn) AS row_num
FROM segmentacion_clientes
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `segmentacion_clientes2` (
  `ï»¿ClienteID` text,
  `Nombre` text,
  `Edad` int DEFAULT NULL,
  `Segmento` text,
  `Saldo` double DEFAULT NULL,
  `Producto` text,
  `FechaRegistro` text,
  `WalletActiva` text,
  `Churn` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM segmentacion_clientes2;


INSERT INTO segmentacion_clientes2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Nombre, Edad, Segmento, Saldo, Producto, FechaRegistro, WalletActiva, Churn) AS row_num
FROM segmentacion_clientes;

DELETE
FROM segmentacion_clientes2
WHERE row_num > 1;

SELECT *
FROM segmentacion_clientes2;

-- Estandarizar datos


SELECT Producto, TRIM(Producto)
FROM segmentacion_clientes2;

UPDATE segmentacion_clientes2
SET Producto = TRIM(Producto);

SELECT 
    ï»¿ClienteID,
    Nombre,
    Edad,
    (Edad - (SELECT AVG(Edad) FROM segmentacion_clientes2)) /
    (SELECT STDDEV(Edad) FROM segmentacion_clientes2) AS Edad_estandarizada
FROM segmentacion_clientes2;

SELECT 
	ï»¿ClienteID,
    Nombre,
    Saldo,
    (Saldo - (SELECT AVG(Saldo) FROM segmentacion_clientes2)) /
    (SELECT STDDEV(Saldo) FROM segmentacion_clientes2) AS Saldo_estandarizado
FROM segmentacion_clientes2;

SELECT 
    ï»¿ClienteID,
    Nombre,
    Edad,
    (Edad - (SELECT AVG(Edad) FROM segmentacion_clientes2)) /
    (SELECT STDDEV(Edad) FROM segmentacion_clientes2) AS Edad_estandarizada,
    Saldo,
    (Saldo - (SELECT AVG(Saldo) FROM segmentacion_clientes2)) /
    (SELECT STDDEV(Saldo) FROM segmentacion_clientes2) AS Saldo_estandarizado
FROM segmentacion_clientes2;


SELECT *
FROM segmentacion_clientes2
WHERE Churn IS NULL;
-- Convertir vacíos en NULL en varias columnas
UPDATE segmentacion_clientes2
SET Nombre   = NULLIF(Nombre, '(vacÃ­o)'),
    Producto = NULLIF(Producto, '(vacÃ­o)'),
    Segmento = NULLIF(Segmento, '(vacÃ­o)'),
    Churn    = NULLIF(Churn, '(vacÃ­o)');
    
UPDATE segmentacion_clientes2
SET Churn = NULL
WHERE Churn = '(vacÃ-o)';

UPDATE segmentacion_clientes2
SET Nombre = NULL
WHERE Nombre = '(vacÃ-o)';

SELECT *
FROM segmentacion_clientes2
;

SELECT * 
FROM segmentacion_clientes2 
WHERE Nombre IS NOT NULL
AND Churn IS NOT NULL;

SELECT *
FROM segmentacion_clientes2;
