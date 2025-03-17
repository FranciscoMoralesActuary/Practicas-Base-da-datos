USE delitos;

# Seleccionamos todas las columnas de la tabla 
SELECT * FROM historico_ny;

#Agrupamos por raza y contamos los registros por grupo
SELECT 
    PERP_RACE, COUNT(*) AS numero
FROM
    historico_ny
GROUP BY PERP_RACE;

#Agrupamos por raza y contamos los registros por grupo y ordenamos
SELECT 
    PERP_SEX, COUNT(*) AS NUM_arrestos
FROM
    historico_ny
GROUP BY PERP_SEX
ORDER BY NUM_arrestos DESC
;

#Numero de arrestos separados por sexo

SELECT 
    PERP_RACE,'FEMALE' as SEX, COUNT(*) AS NUM_arrestos
FROM
    historico_ny
WHERE
    PERP_SEX = 'F'
GROUP BY PERP_RACE
ORDER BY NUM_arrestos DESC
LIMIT 1;

## EJERCICIO 1 TAREA

# ¿Cuál es la raza que tiene mayor crecimiento en arrestos si comparamos 
#el primer semestre de 2020 con el primer semestre de 2019?

# RAZA CANT_ARREST 2019, CANT_2020 INCREMENTO

# TABLA 1

USE delitos;

SELECT 
    PERP_RACE, COUNT(*) AS ARRESTOS_2019
FROM
    historico_ny
WHERE
    ARREST_DATE < '2019-07_01'
        AND ARREST_DATE >= '2019-01_01'
GROUP BY PERP_RACE
ORDER BY ARRESTOS_2019 DESC;

# TABLA 2
SELECT 
    PERP_RACE, COUNT(*) AS ARRESTOS_2020
FROM
    historico_ny
WHERE
    ARREST_DATE < '2020-07_01'
        AND ARREST_DATE >= '2020-01_01'
GROUP BY PERP_RACE
ORDER BY ARRESTOS_2020 DESC;

## UNIMOS TABLAS

SELECT 
    A.PERP_RACE,
    A.ARRESTOS_2020 AS ACTUAL,
    B.ARRESTOS_2019 AS ANTES,
    (A.ARRESTOS_2020 - B.ARRESTOS_2019) / B.ARRESTOS_2019 AS TASA
FROM
    (SELECT 
        PERP_RACE, COUNT(*) AS ARRESTOS_2020
    FROM
        historico_ny
    WHERE
        ARREST_DATE < '2020-07_01'
            AND ARREST_DATE >= '2020-01_01'
    GROUP BY PERP_RACE
    ORDER BY ARRESTOS_2020 DESC) A
        INNER JOIN
    (SELECT 
        PERP_RACE, COUNT(*) AS ARRESTOS_2019
    FROM
        historico_ny
    WHERE
        ARREST_DATE < '2019-07_01'
            AND ARREST_DATE >= '2019-01_01'
    GROUP BY PERP_RACE
    ORDER BY ARRESTOS_2019 DESC) B ON A.PERP_RACE = B.PERP_RACE
ORDER BY TASA DESC;