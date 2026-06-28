/*
============================================================
Project : Banking Data Engineering
Author  : Your Name
Purpose : Create database schemas
============================================================
*/

------------------------------------------------------------
-- Drop Schemas (Development Only)
------------------------------------------------------------

DROP SCHEMA IF EXISTS raw CASCADE;
DROP SCHEMA IF EXISTS staging CASCADE;
DROP SCHEMA IF EXISTS warehouse CASCADE;
DROP SCHEMA IF EXISTS analytics CASCADE;

------------------------------------------------------------
-- Create Schemas
------------------------------------------------------------

CREATE SCHEMA raw;

CREATE SCHEMA staging;

CREATE SCHEMA warehouse;

CREATE SCHEMA analytics;

------------------------------------------------------------
-- Schema Comments
------------------------------------------------------------

COMMENT ON SCHEMA raw IS
'Landing schema for metadata and raw ingestion information';

COMMENT ON SCHEMA staging IS
'Temporary staging tables loaded from AWS S3 Gold layer';

COMMENT ON SCHEMA warehouse IS
'Enterprise Data Warehouse';

COMMENT ON SCHEMA analytics IS
'Business views for BI reporting';