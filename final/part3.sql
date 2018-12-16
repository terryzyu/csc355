--A2
CREATE INDEX partIndex ON part(p_name);


--C1
CREATE MATERIALIZED VIEW conversionRate
ENABLE QUERY REWRITE AS
SELECT  c_custkey,  SUM(lo_revenue) AS US_Currency, 
                    (SUM(lo_revenue) * 6.94) AS Chinese_Yuan, 
                    (SUM(lo_revenue) * 1.32) AS Canadian_Dollar, 
                    (SUM(lo_revenue) * 3.74) AS Brazilian_Real, 
                    (SUM(lo_revenue) * 102.26) AS Kenyan_Shilling, 
                    (SUM(lo_revenue) * 23138.50) AS Vietnamese_Dong, 
                    (SUM(lo_revenue) * 0.00018) AS Bitcoin
FROM customer_t2, lineorder
WHERE lo_custkey = c_custkey group by c_custkey;

SELECT * FROM conversionRate;