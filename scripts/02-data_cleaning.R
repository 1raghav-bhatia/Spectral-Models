#### Preamble ####
# Purpose: Cleans and prepares the S&P 500 and VIX index data for financial analysis.
# Author: Raghav Bhatia
# Date: 16 April 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the raw data downloaded and stored as Parquet files.

#### Workspace setup ####
library(quantmod)
library(arrow)
library(forecast)
library(wavethresh)
library(tidyverse)

#### Clean data ####

### Reading Data
# Reading the raw data
sp500_raw <- arrow::read_parquet("data/raw_data/sp500_data.parquet")
vix_raw <- arrow::read_parquet("data/raw_data/vix_data.parquet")

### Transforming Data to Monthly Returns and Cleaning
# S&P 500
sp500_monthly <- to.monthly(sp500_raw, indexAt = "lastof", OHLC = FALSE)
sp500_returns <- ROC(Cl(sp500_monthly)) * 100  # Convert to percentage returns
sp500_clean <- na.omit(sp500_returns)  # Remove NAs

# VIX
vix_monthly <- to.monthly(vix_raw, indexAt = "lastof", OHLC = FALSE)
vix_clean <- ROC(Cl(vix_monthly)) * 100
vix_clean <- na.omit(vix_clean)

### Analyzing Data
# Fit ARIMA model on S&P 500 monthly returns
arima_sp500 <- auto.arima(sp500_clean)

# Plot the fitted ARIMA model
plot(sp500_clean, main = "Fitted ARIMA Model for S&P 500", col = "blue")
lines(fitted(arima_sp500), col = "red")
legend("topright", legend = c("Actual", "Fitted"), col = c("blue", "red"), lty = 1)

# Apply Discrete Haar Transform to ARIMA residuals
dht_residuals <- dwt(residuals(arima_sp500), filter = "haar", boundary = "periodic")
details_residuals <- dht_residuals@W

# Plotting detailed coefficients of residuals
par(mfrow = c(2, 2))
for (i in 1:7) {
  plot(details_residuals[[i]], type = 'l', main = paste("Detail Residuals at Level", i))
}

# VIX data analysis using DHT
vix_data_vector <- coredata(vix_clean)
vix_dht <- dwt(vix_data_vector, filter = "haar", boundary = "periodic")
details_vix <- vix_dht@W

# Plotting detailed coefficients of VIX
par(mfrow = c(2, 2))
for (i in 1:7) {
  plot(details_vix[[i]], type = 'l', main = paste("Detail VIX at Level", i))
}

### Saving Processed Data
# Save detailed coefficients of market shocks and VIX
details_market_df <- data.frame(Market_Return_Detail = details_residuals[[1]]) |> round(digits = 3)
details_vix_df <- data.frame(VIX_Detail = details_vix[[1]]) |> round(digits = 3)

arrow::write_parquet(details_market_df, 
                     "data/cleaned_data/detail_coefficients_market_shock.parquet")
arrow::write_parquet(details_vix_df, 
                     "data/cleaned_data/detail_coefficients_vix.parquet")


