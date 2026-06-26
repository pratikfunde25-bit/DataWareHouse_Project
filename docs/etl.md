# ETL Flow

1. Source CSV files are placed under `datasets/`.
2. Bronze scripts load raw CRM and ERP files into `dw_bronze`.
3. Silver scripts cleanse and standardize records into `dw_silver`.
4. Gold scripts shape analytics-ready models in `dw_gold`.
5. Quality checks validate Silver and Gold outputs.
