#### Preamble ####
# Purpose: Downloads and saves the raw daily S&P 500 and VIX index data from Yahoo Finance
# for analysis of market fluctuations and volatility expectations.
# Author: Raghav Bhatia
# Date: 12 April 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(quantmod)
library(arrow)
library(xts)

#### Download data ####

## Downloading the S&P 500 data
sp500_data <- getSymbols("^GSPC", src = "yahoo", from = "1993-01-01", to = "2023-12-31", auto.assign = FALSE)

## Downloading the VIX index data
vix_data <- getSymbols("^VIX", src = "yahoo", from = "1993-03-01", to = "2024-02-29", auto.assign = FALSE)

#### Save data ####

# Convert to xts
sp500_xts <- as.xts(sp500_data)
vix_xts <- as.xts(vix_data)

# Convert xts to data frame before saving as Parquet
sp500_df <- data.frame(date = index(sp500_xts), coredata(sp500_xts))
vix_df <- data.frame(date = index(vix_xts), coredata(vix_xts))

# Save data as Parquet
arrow::write_parquet(sp500_df, "data/raw_data/sp500_data.parquet")
arrow::write_parquet(vix_df, "data/raw_data/vix_data.parquet")


         
