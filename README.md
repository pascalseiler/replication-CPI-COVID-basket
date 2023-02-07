# Weighting bias and inflation in the time of COVID-19
This repository contains the files to replicate the main results in "Weighting bias and inflation in the time of COVID-19: evidence from Swiss transaction data".

Reference: Seiler (2020), "Weighting bias and inflation in the time of COVID-19: evidence from Swiss transaction data", https://sjes.springeropen.com/articles/10.1186/s41937-020-00057-7 (SJES article).

Tested in: R version 4.1.2 on Windows 10 (64-bit).

# Contents

[main.R](R/main.R): Main shell to load the data, make the calculations and produce the main results.

[\R](R/): Subscripts called in `main.R`
   * [get_CPI_data_agg.R](R/get_CPI_data_agg.R): load and transform aggregate CPI data
   * [get_CPI_data_HG.R](R/get_CPI_data_HG.R): load and transform CPI data per main group (HG)
   * [get_CPI_data_IP.R](R/get_CPI_data_IP.R): load and transform CPI data per expenditure item (IP)
   * [get_debitcard_data.R](R/get_debitcard_data.R): load and transform debit card transactions data
   * [calc_COVID_weights.R](R/calc_COVID_weights.R): calculate COVID weights for expenditure items and main groups
   * [calc_COVID_inflation.R](R/calc_COVID_inflation.R): calculate COVID inflation for expenditure items and main groups
   * [figure_1.R](R/figure_1.R): produce Figure 1
   * [figure_2.R](R/figure_2.R): produce Figure 2
   * [table_2.R](R/table_2.R): produce Table 2
   * [table_3.R](R/table_3.R): produce Table 3
   
[\data](data/): Data for analysis
   * [su-d-05.02.68.xlsx](data/su-d-05.02.68.xlsx): CPI data (aggregate, main groups, expenditure items)
   * [CPI_Weights.xlsx](data/CPI_Weights.xlsx): CPI weights (aggregate, main groups, expenditure items)
   * [Merchanttype_Grossregion.csv](data/Merchanttype_Grossregion.csv): Debit card transactions data
      * [README_BEFORE_DOWNLOADING_DATA.pdf](data/README_BEFORE_DOWNLOADING_DATA.pdf): README for debit card transactions data
   * [Mapping_MCC_IP.xlsx](data/Mapping_MCC_IP.xlsx): Mapping between debit card transactions categories (MCC) and CPI expenditure items (IP)
   * [HGWeights_CovidAddOns.xlsx](data/HGWeights_CovidAddOns.xlsx): COVID weights per main group
   
[\figs](figs/): Stores figures from analysis

[\output](output/): Stores tables from analysis

[Paper](paper.pdf): PDF containing paper and appendix
