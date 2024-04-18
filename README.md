# Beyond Efficient Markets

## Overview

The repository contains all related coding scripts and materials used to create the research paper "Beyond Efficient Markets: Unveiling the Predictive Power of Short-Term Market Shocks".

## File Structure

The structure of the repo is:

-   `data/raw_data/sp500_data.parquet` is the raw data containing only demographic variables obtained from 1993 January till 2023 December obtained from Yahoo Finance.
-   `data/raw_data/vix_data.parquet` is the raw data containing only VIX index data from 1993 March till 2024 February obtained from Yahoo Finance.
-   `data/cleaned_data/detail_coefficients_market_shock.parquet` is the cleaned detail 1 coefficients.
-   `data/cleaned_data/detail_coefficients_vix.parquet` is the cleaned detail 1 coefficients.
-   `model` contains the market shocks model which gives the linear model used. 
-   `other` contains details on LLM usage and sketches
-   `paper` contains the qmd file used to render the research paper, along with the pdf of the paper, and reference bibliography file. It also contains a duplicate copy of the data folder which helps in faster rendering the qmd file. 
-   `scripts` contains the R scripts used to simulate the data, download and clean it, test it, and model it. It also contains a duplicate copy of the data folder which helps in running the testing script.

## Statement on LLM usage

The following large language model was used for coding and writing this paper. The usage is documented in the usage.txt file within the `other\LLM` folder:

- ChatGPT 4
