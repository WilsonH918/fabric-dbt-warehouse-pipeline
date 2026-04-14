# fabric_dbt – Microsoft Fabric Warehouse dbt Project (Bronze / Silver / Gold)

This repository contains a dbt project targeting Microsoft Fabric Warehouse, organised using a Bronze, Silver, Gold layered approach.

The focus of this project is:
- building Silver models from Bronze sources
- building Gold star schema models (dims and facts)
- providing a Gold denormalised mart for BI consumption
- enabling dbt tests, lineage, and dbt Docs

---

## Prerequisites

1. dbt Core installed
2. dbt-fabric adapter installed
3. Microsoft ODBC Driver installed (17 or 18)
4. Access to a Fabric Warehouse (and the schemas used in this project)

---

## Repository Structure

models
- bronze
  - sources.yml
- silver
  - slv_dim_date.sql
  - slv_dim_symbol.sql
  - slv_fact_basic_financials.sql
- gold
  - gld_dim_date.sql
  - gld_dim_symbol.sql
  - gld_fact_basic_financials.sql
  - gld_financials_denorm.sql
  - schema.yml

macros
- generate_schema_name.sql

root files
- dbt_project.yml
- profiles.yml
- import_env.ps1
- README.md

---

## Layering Rules

Bronze
- Bronze tables already exist in the Warehouse (created outside of dbt)
- dbt references Bronze as sources only
- dbt does not build models in Bronze unless you add Bronze SQL models

Silver
- Silver contains cleaned and standardised transformations
- Silver models are designed to be stable building blocks for Gold

Gold
- Gold contains presentation-ready models
- Gold includes a star schema and a denormalised mart for BI tools

---

## Schema Behaviour (Important)

This project uses folder-level +schema configuration in dbt_project.yml to map:
- models/bronze to schema bronze
- models/silver to schema silver
- models/gold to schema gold

dbt by default may concatenate target.schema and custom schema. This project can include a macro (macros/generate_schema_name.sql) to force clean schema names so models land in exactly bronze, silver, gold as intended.

If you see schemas like bronze_silver or bronze_gold, it means your target schema from profiles.yml is being concatenated with your folder schema. Use the generate_schema_name macro to make schema names clean.

---

## Environment Variables

dbt does not automatically load .env files.
This project expects environment variables to be available in your terminal session before running dbt.

Required environment variables:
FABRIC_HOST
FABRIC_DATABASE
FABRIC_SCHEMA
FABRIC_TENANT_ID
FABRIC_CLIENT_ID
FABRIC_CLIENT_SECRET

Notes:
- FABRIC_DATABASE is your Fabric Warehouse name
- FABRIC_SCHEMA is your default target schema (often set to bronze, or a neutral schema)
- The folder-level +schema rules will override schema per layer

---

## Loading .env into your PowerShell session

This repository includes a helper script:
import_env.ps1

Run it once per terminal session before running dbt commands:
.\import_env.ps1

After running it, you can validate values exist:
echo $env:FABRIC_DATABASE
echo $env:FABRIC_HOST
echo $env:FABRIC_SCHEMA

If any of these are empty, dbt will fail during parsing with an error like:
Env var required but not provided

---

## Common dbt Commands

Run dbt connectivity checks:
dbt debug

Run everything:
dbt run

Run only Silver:
dbt run --select silver

Run only Gold:
dbt run --select gold

Run one model:
dbt run --select slv_fact_basic_financials

Run tests:
dbt test

Run tests for Gold only:
dbt test --select gold

Clean cached artifacts:
dbt clean

---

## Documentation (dbt Docs)

Generate docs artifacts:
dbt docs generate

Serve docs locally:
dbt docs serve

Typical workflow:
dbt docs generate
dbt docs serve

If you recently renamed models, changed schema config, or changed profiles:
dbt clean
dbt docs generate
dbt docs serve

---

## Modelling Conventions

Model naming
- Silver models use prefix slv_
- Gold models use prefix gld_

Key naming
- Primary keys use pk_
- Foreign keys use fk_

Gold layer modelling
- gld_dim_date is the date dimension
- gld_dim_symbol is the symbol dimension
- gld_fact_basic_financials is the fact table with fk_symbol and fk_date_key
- gld_financials_denorm is the denormalised mart for BI

dbt tests
- Primary keys should be not_null and unique
- Foreign keys should use relationships tests to referenced dims
- Tests are declared in models/gold/schema.yml

---

## Quick Start

1. Load env vars into your PowerShell session:
.\import_env.ps1

2. Confirm dbt can connect:
dbt debug

3. Build Silver then Gold:
dbt run --select silver
dbt run --select gold

4. Run tests:
dbt test --select gold

5. Generate and view docs:
dbt docs generate
dbt docs serve

---

## Notes and Troubleshooting

If you see:
dbt found two models with the name "X"
It means two SQL files in this project compile to the same model name. Model names must be unique within a dbt project. Rename one of them (recommended approach is to prefix by layer: slv_ and gld_).

If you see:
Invalid object name '... bronze.symbol'
It usually means your sources.yml table name does not match the actual table name in the Warehouse. Confirm the exact schema and table names in Fabric and update models/bronze/sources.yml accordingly.

If you see:
Unable to do partial parsing because profile has changed
That is normal when you update profiles.yml, dbt_project.yml, macros, or env vars. Running dbt clean can help when debugging.