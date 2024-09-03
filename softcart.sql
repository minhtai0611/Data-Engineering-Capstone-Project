-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public."softcartDimDate"
(
    dateid serial NOT NULL,
    date date NOT NULL,
    day integer NOT NULL,
    month integer NOT NULL,
    monthname character varying(20) NOT NULL,
    quarter integer NOT NULL,
    year integer NOT NULL,
    weekday integer NOT NULL,
    weekdayname character varying(20) NOT NULL,
    isweekend boolean NOT NULL,
    dayofyear integer NOT NULL,
    isleapyear boolean NOT NULL,
    PRIMARY KEY (dateid)
);

CREATE TABLE IF NOT EXISTS public."softcartDimCategory"
(
    categoryid serial NOT NULL,
    categoryname character varying(100) NOT NULL,
    subcategoryid serial NOT NULL,
    subcategoryname character varying(100) NOT NULL,
    categorydesc text NOT NULL,
    PRIMARY KEY (categoryid)
);

CREATE TABLE IF NOT EXISTS public."softcartDimItem"
(
    itemid serial NOT NULL,
    itemname character varying(255) NOT NULL,
    categoryid serial NOT NULL,
    price double precision NOT NULL,
    itemdesc text NOT NULL,
    suppliername character varying(255) NOT NULL,
    supplierid serial NOT NULL,
    created_date date NOT NULL,
    PRIMARY KEY (itemid, categoryid)
);

CREATE TABLE IF NOT EXISTS public."softcartDimCountry"
(
    countryid serial NOT NULL,
    countryname character varying(100) NOT NULL,
    countrycode character varying(10) NOT NULL,
    continent character varying(100) NOT NULL,
    region character varying(100) NOT NULL,
    population integer NOT NULL,
    gdp double precision NOT NULL,
    PRIMARY KEY (countryid)
);

CREATE TABLE IF NOT EXISTS public."softcartFactSales"
(
    salesid serial NOT NULL,
    dateid serial NOT NULL,
    itemid serial NOT NULL,
    categoryid serial NOT NULL,
    countryid serial NOT NULL,
    quantity integer NOT NULL,
    total_sales double precision NOT NULL,
    PRIMARY KEY (salesid, dateid, itemid, categoryid, countryid)
);

ALTER TABLE IF EXISTS public."softcartDimItem"
    ADD FOREIGN KEY (categoryid)
    REFERENCES public."softcartDimCategory" (categoryid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."softcartFactSales"
    ADD FOREIGN KEY (dateid)
    REFERENCES public."softcartDimDate" (dateid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."softcartFactSales"
    ADD FOREIGN KEY (itemid)
    REFERENCES public."softcartDimItem" (itemid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."softcartFactSales"
    ADD FOREIGN KEY (countryid)
    REFERENCES public."softcartDimCountry" (countryid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."softcartFactSales"
    ADD FOREIGN KEY (categoryid)
    REFERENCES public."softcartDimCategory" (categoryid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;