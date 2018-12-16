--PART 1.A, first trigger
CREATE OR REPLACE TRIGGER enforceCityNation
BEFORE INSERT OR UPDATE OR DELETE
ON CUSTOMER_T1
FOR EACH ROW
DECLARE
    holder NUMBER;
BEGIN
    BEGIN
        SELECT COUNT(*) INTO holder
        FROM customer_t1, customer_t2
        WHERE customer_t1.c_custkey = customer_t2.c_custkey
        AND customer_t2.c_custkey = :new.c_custkey
        AND :new.c_city = customer_t1.c_city
        AND :new.c_custkey != customer_t2.c_custkey;
    END;
    IF(holder > 0) THEN
        RAISE_APPLICATION_ERROR(-2018, 'City Nation FD violated');
    END IF;
END;
/

--Part 1.A, second trigger
CREATE OR REPLACE TRIGGER enforceCityNation2
BEFORE INSERT OR UPDATE OR DELETE
ON CUSTOMER_T2
FOR EACH ROW
DECLARE
    holder NUMBER;
BEGIN
    BEGIN
        SELECT COUNT(*) INTO holder
        FROM customer_t1, customer_t2
        WHERE customer_t1.c_custkey = customer_t2.c_custkey
        AND customer_t2.c_custkey = :new.c_custkey
        AND :new.c_custkey != customer_t2.c_custkey;
    END;
    IF(holder > 0) THEN
        RAISE_APPLICATION_ERROR(-2018, 'City Nation FD violated');
    END IF;
END;
/

--Part 1.B
CREATE OR REPLACE TRIGGER updateTotalOrderPrice
BEFORE INSERT OR UPDATE OR DELETE
ON lineorder
FOR EACH ROW
BEGIN
    IF(:new.lo_ordertotalprice != :old.lo_ordertotalprice)THEN
        UPDATE customer_t2 ct2
        set ct2.c_totalorderprice = :new.lo_ordertotalprice
        where ct2.c_custkey = :new.lo_custkey;
    END IF;
END;
/

--Part 1.C
CREATE OR REPLACE TRIGGER validOrderDays
INSTEAD OF INSERT
ON LineOrderView
DECLARE
    d1 DATE;
    day VARCHAR2(10);
BEGIN
    d1 := to_date(:new.lo_orderdate, 'YYYY-MM-DD');
    day := TO_CHAR(d1, 'DAY');
    IF (NOT(day = 'THURSDAY' OR day = 'FRIDAY' OR  day = 'SATURDAY' OR day = 'SUNDAY')) THEN
        INSERT INTO LineOrder VALUES(:new.lo_orderkey, :new.lo_linenumber, 
                                        :new.lo_custkey, :new.lo_partkey, 
                                        :new.lo_suppkey, :new.lo_orderdate, 
                                        :new.lo_orderpriority, :new.lo_shippriority, 
                                        :new.lo_quantity, :new.lo_extendedprice, 
                                        :new.lo_ordertotalprice, :new.lo_discount, 
                                        :new.lo_revenue, :new.lo_supplycost, 
                                        :new.lo_tax, :new.lo_commitdate, :new.lo_shipmode);
    END IF;
END;
/