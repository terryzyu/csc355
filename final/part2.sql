--B
SELECT AVG(lo_discount) as average, 
MAX(lo_discount) as maxVal, 
MIN(lo_discount) as minVal
FROM LineOrder, SUPPLIER
WHERE s_nation != 'CANADA'
AND s_address LIKE '%,%'
AND lo_custkey = s_suppkey;

--D
SELECT COUNT(lo_shippriority), COUNT(c_mktsegment)
FROM LINEORDER, CUSTOMER_T2, part
WHERE lo_custkey = c_custkey 
AND lo_partkey = p_partkey
AND REGEXP_LIKE(p_container, '\s[A-z]{4}+');


--E 
SELECT lo_orderdate, lo_orderpriority, lo_shippriority, lo_revenue, lo_tax
FROM lineorder, dwdate
WHERE lo_orderdate = d_datekey AND lo_suppkey IN 
(SELECT s_suppkey FROM supplier WHERE s_city LIKE '% %')
ORDER BY d_daynuminweek;

--F
SELECT d_daynuminweek, d_month, d_year
FROM lineorder, dwdate
WHERE lo_orderdate = d_datekey
AND lo_quantity > (SELECT AVG(lo_quantity) FROM lineorder)
ORDER BY d_year DESC;

--G
SELECT c_nation
FROM customer_t2, supplier
WHERE c_nation = s_nation
GROUP BY c_nation
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                        FROM customer_t2, supplier
                        WHERE c_nation = s_nation
                        GROUP BY c_nation);

--H
SELECT * FROM PART
WHERE p_name LIKE '%'||p_color||'%';

--I
SELECT DISTINCT c_name
FROM customer_t2, customer_t1, part, supplier, lineorder
WHERE customer_t2.c_custkey = customer_t1.c_custkey
AND customer_t1.c_custkey = lo_custkey
AND lo_partkey = p_partkey
AND lo_suppkey = s_suppkey
AND c_region != s_region
AND p_size > (SELECT AVG(p_size) FROM part);
