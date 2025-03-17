-- Viaje más caro
SELECT 
    *
FROM
    taxis.viajes
ORDER BY trip_total DESC
LIMIT 1

SELECT 
    *
FROM
    taxis.viajes
WHERE
    trip_total IN (SELECT 
            MAX(trip_total)
        FROM
            taxis.viajes)

-- Costo por km
SELECT 
    trip_total,
    trip_miles * 1.6 AS trip_km,
    trip_total / (trip_miles * 1.6) AS costo_x_km
FROM
    taxis.viajes

SELECT 
    AVG(trip_total) AS prom_costo,
    AVG(trip_km) AS prom_distancia,
    AVG(costo_x_km) AS costo_x_km
FROM
    (SELECT 
        trip_total,
            trip_miles * 1.6 AS trip_km,
            trip_total / (trip_miles * 1.6) AS costo_x_km
    FROM
        taxis.viajes) AS viajes 
SELECT 
    COUNT(*)
FROM
    taxis.viajes
WHERE
    trip_miles * 1.6 > 10
        AND payment_type = 'Credit Card'

#Tasa de incremento de ingreso mensual
-- ¿Cuántos ingreso hay cada mes?
select
	mes,
	round((actual-anterior)/ anterior, 2) as tasa_crec
from
	(
	select
		mes,
		ingreso_total as actual,
		LAG(ingreso_total, 1) over (
		order by mes) as anterior
	from
		(
		SELECT
			DATE_FORMAT(trip_start_timestamp, '%Y-%m') AS mes,
			round(SUM(trip_total), 2) AS ingreso_total
		FROM
			taxis.viajes
		GROUP BY
			mes
		order by
			mes) as ingresos) as comparativo;