SELECT * from warehouse

SELECT max(event_dateTime) -90 from warehouse

with minu as (SELECT case when event_dateTime > '2019-08-18 00:45:00' then event_dateTime else null end as e from warehouse) 
SELECT min(e)
FROM minu


SELECT TOP 1 OnHandQuantity from warehouse

with a as (SELECT OnHandQuantityData from warehouse 
where event_datetime >
(SELECT max(event_dateTime) -90 from warehouse) 
AND event_type = 'InBound') 
SELECT case when SUM(OnHandQuantityData) < (SELECT TOP 1 OnHandQuantity from warehouse) then SUM(OnHandQuantityData) else (SELECT TOP 1 OnHandQuantity from warehouse) end days_0_to_90 from a

with b as (SELECT OnHandQuantityData from warehouse 
where event_datetime >
(SELECT max(event_dateTime) -180 from warehouse)
AND event_datetime <
(SELECT max(event_dateTime) -90 from warehouse)
AND event_type = 'InBound')
SELECT SUM(OnHandQuantityData) days_91_to_180 from b

with c as (SELECT OnHandQuantityData from warehouse 
where event_datetime >
(SELECT max(event_dateTime) -270 from warehouse)
AND event_datetime <
(SELECT max(event_dateTime) -180 from warehouse)
AND event_type = 'InBound')
SELECT SUM(OnHandQuantityData) days_180_to_270 from c



WITH WH as 
(SELECT * FROM warehouse),

days as 
(select TOP 1 onhandquantity, event_datetime, 
(event_datetime - 90) as day90,
(event_datetime - 180) as day180,
(event_datetime - 270) as day270,
(event_datetime - 365) as day365
from WH),

inv_90_days as 
(select sum(OnHandQuantityData) as DaysOld_90 from WH 
cross join days d
where event_type = 'InBound' AND WH.event_datetime >= d.day90),

inv_90_days_final as 
(select case when DaysOld_90 > d.onhandquantity then d.onhandquantity else DaysOld_90 end final1
from inv_90_days
cross join days d ),

inv_180_days as 
(select sum(OnHandQuantityData) as DaysOld_180 from WH 
cross join days d
where event_type = 'InBound' AND WH.event_datetime BETWEEN d.day180 AND d.day90),

inv_180_days_final as 
(select case when DaysOld_180 > (d.onhandquantity-i.final1) then (d.onhandquantity-i.final1) else DaysOld_180 end final2
from inv_180_days
cross join days d 
cross join inv_90_days_final i),

inv_270_days as 
(select coalesce (sum(OnHandQuantityData),0) as DaysOld_270 from WH 
cross join days d
where event_type = 'InBound' AND WH.event_datetime BETWEEN d.day270 AND d.day180),

inv_270_days_final as 
(select case when DaysOld_270 > (d.onhandquantity-i.final2-f.final1) then (d.onhandquantity-i.final2) else DaysOld_270 end final3
from inv_270_days
cross join days d 
cross join inv_90_days_final f
cross join inv_180_days_final i),

inv_365_days as 
(select coalesce (sum(OnHandQuantityData),0) as DaysOld_365 from WH 
cross join days d
where event_type = 'InBound' AND WH.event_datetime BETWEEN d.day365 AND d.day270),

inv_365_days_final as 
(select case when DaysOld_365 > (d.onhandquantity-i.final2-f.final1-k.final3) then (d.onhandquantity-k.final3) else DaysOld_365 end final4
from inv_365_days
cross join days d 
cross join inv_90_days_final f
cross join inv_180_days_final i
cross join inv_270_days_final k)



SELECT final1 as "0-90 days", final2 as "91-180 days", final3 as "181-270 days", final4 as "270-365 days" from inv_90_days_final 
cross join inv_180_days_final
cross join inv_270_days_final
cross join inv_365_days_final
