USE jw_db_unificada;

-- Tabla de productos
CREATE TABLE datos_JW (
	pais_territorio VARCHAR (100),
    Max_publicadores INT,
	Bautizados INT,
	Prom_precursores INT,
	Congregaciones INT,
	Asistencia_conmemoracion INT,
	Año INT
    
);

SELECT * FROM datos_JW;

TRUNCATE TABLE datos_JW;
DESCRIBE datos_JW;
SELECT DISTINCT pais_territorio FROM datos_JW;
SELECT COUNT(*) FROM datos_JW;

-- Qué país tiene más publicadores
SELECT año, pais_territorio, Max_publicadores
FROM datos_JW
ORDER BY Max_publicadores DESC
LIMIT 10;

-- asistencia a conmemoracion por año 
SELECT Año, SUM(Asistencia_conmemoracion) AS Total_Asistencia
FROM datos_JW
GROUP BY Año
ORDER BY Año;

--  publicadores por año 
SELECT Año, sum(Max_publicadores) AS Promedio_Publicadores
FROM datos_JW
GROUP BY Año
ORDER BY Año;

-- País con mayor asistencia a la Conmemoración
SELECT año, pais_territorio, Asistencia_conmemoracion
FROM datos_JW
ORDER BY Asistencia_conmemoracion DESC
LIMIT 10;

SELECT pais_territorio, SUM(Bautizados) AS Total_Bautizados
FROM datos_JW
GROUP BY pais_territorio
ORDER BY Total_Bautizados DESC
LIMIT 5;
