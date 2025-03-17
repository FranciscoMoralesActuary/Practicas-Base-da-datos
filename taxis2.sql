-- 1. Determine la distancia promedio recorrida cada mes por los conductores
use taxis;

select
	mes,
	avg(distancia_total) as dist_prom
from
	(
	select
		DATE_FORMAT(trip_start_timestamp, '%Y-%m') as mes,
		taxi_id,
		sum(trip_miles) as distancia_total
	from
		viajes
	where
		taxi_id is not null
	group by
		mes,
		taxi_id
) distTotal
group by
	mes
order by
	mes
;

-- 2. Determine el ingreso mínimo,ingreso medio e ingreso máximo por mes de los conductores
select
	mes,
	min(ingreso) as ing_min,
	avg(ingreso) as ing_medio,
	max(ingreso) as ing_max
from
	(
	SELECT
		taxi_id,
		DATE_FORMAT(trip_start_timestamp, '%Y-%m') as mes,
		sum(trip_total) as ingreso
	from
		viajes
	where
		taxi_id is not null
	group by
		taxi_id,
		mes
) ingTotal
group by
	mes
order by
	mes
-- 3. Calcule la tendencia histórica de los pagos realizados por tarjeta de crédito y efectivo
select
	DATE_FORMAT(trip_start_timestamp, '%Y-%m') as mes,
	sum(case when payment_type = 'Cash' then trip_total else 0 end) as Cash ,
	sum(case when payment_type = 'Credit Card' then trip_total else 0 end) as Credit_Card
from
	viajes
where
	payment_type in ('Cash', 'Credit Card')
group by
	mes ;
-- 4. Genere un mapa de los destinos de viaje para el top 20 de los 
-- conductores (por número de viajes)

;
create table top20 as 
select
		taxi_id
from
		(
	select
			taxi_id,
			ROW_NUMBER () over (
	order by
			num_viajes desc) as fila
	from
			(
		select
				taxi_id,
				count(*) as num_viajes
		from
				viajes
		where
				taxi_id is not NULL
		group by
				taxi_id) as totalViajes) as top
where
		fila <= 20;
select
	viajes.taxi_id,
	viajes.trip_start_timestamp ,
	plat.pickup_latitude,
	plon.pickup_longitude,
	dlat.dropoff_latitude,
	dlon.dropoff_longitude
from
	viajes
inner join 
pickupLatitude plat on
	viajes.pickup_latitude = plat.pickup_latitude_clave
inner join pickupLongitude plon on
	viajes.pickup_longitude = plon.pickup_longitude_clave
inner join dropoffLatitude dlat on
	viajes.dropoff_latitude = dlat.dropoff_latitude_clave
inner join dropoffLongitude dlon on
	viajes.dropoff_longitude = dlon.dropoff_longitude_clave
inner join top20
	
	 on
	top20.taxi_id = viajes.taxi_id
	
	
	
	