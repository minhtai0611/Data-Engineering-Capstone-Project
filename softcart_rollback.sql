-- Rollback the current transaction
ROLLBACK;

-- Start a new transaction
BEGIN;

-- Drop existing tables if they exist (to ensure a clean slate)
DROP TABLE IF EXISTS public."softcartFactSales";
DROP TABLE IF EXISTS public."softcartDimItem";
DROP TABLE IF EXISTS public."softcartDimCategory";
DROP TABLE IF EXISTS public."softcartDimCountry";
DROP TABLE IF EXISTS public."softcartDimDate";

-- Create the dimension tables
CREATE TABLE IF NOT EXISTS public."softcartDimDate"
(
    dateid serial PRIMARY KEY,
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
    isleapyear boolean NOT NULL
);

CREATE TABLE IF NOT EXISTS public."softcartDimCategory"
(
    categoryid serial PRIMARY KEY,
    categoryname character varying(100) NOT NULL,
    subcategoryid serial,
    subcategoryname character varying(100),
    categorydesc text
);

CREATE TABLE IF NOT EXISTS public."softcartDimItem"
(
    itemid serial PRIMARY KEY,
    itemname character varying(255) NOT NULL,
    categoryid integer NOT NULL,
    price double precision NOT NULL,
    itemdesc text NOT NULL,
    suppliername character varying(255) NOT NULL,
    supplierid integer NOT NULL,
    created_date date NOT NULL,
    FOREIGN KEY (categoryid) REFERENCES public."softcartDimCategory" (categoryid) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public."softcartDimCountry"
(
    countryid serial PRIMARY KEY,
    countryname character varying(100) NOT NULL,
    countrycode character varying(10) NOT NULL,
    continent character varying(100) NOT NULL,
    region character varying(100) NOT NULL,
    population integer NOT NULL,
    gdp double precision NOT NULL
);

CREATE TABLE IF NOT EXISTS public."softcartFactSales"
(
    salesid serial PRIMARY KEY,
    dateid integer NOT NULL,
    itemid integer NOT NULL,
    categoryid integer NOT NULL,
    countryid integer NOT NULL,
    quantity integer NOT NULL,
    total_sales double precision NOT NULL,
    FOREIGN KEY (dateid) REFERENCES public."softcartDimDate" (dateid) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (itemid) REFERENCES public."softcartDimItem" (itemid) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (categoryid) REFERENCES public."softcartDimCategory" (categoryid) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (countryid) REFERENCES public."softcartDimCountry" (countryid) ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Commit the transaction
COMMIT;
