#### Preamble ####
# Purpose: Tests the cleaned datasets of residual and VIX level one coefficients
# Author: Raghav Bhatia 
# Date: 16 April 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

#### Test data ####

# Reads the cleaned datasets

residuals_data <- 
  read_parquet("data/cleaned_data/detail_coefficients_vix.parquet")
vix_data <- 
  read_parquet("data/cleaned_data/detail_coefficients_market_shock.parquet")

## Testing Residuals Data

# Test if the residuals dataset has the expected number of entries
test_that("Residuals dataset has the expected number of entries", {
  expect_equal(nrow(residuals_data), 186)  # Assuming 185 is the expected number of entries
})


# Test the range of 'Residuals_Detail' values
test_that("Residuals Detail values are within expected range", {
  expect_true(all(residuals_data$Residuals_Detail > -100 & residuals_data$Residuals_Detail < 100))
})

# Test for the presence of NA values in the residuals dataset
test_that("No NA values are present in the residuals dataset", {
  expect_true(all(complete.cases(residuals_data)))
})

## Testing VIX Data

# Test if the VIX dataset has the expected number of entries
test_that("VIX dataset has the expected number of entries", {
  expect_equal(nrow(vix_data), 185)  # Matching the residuals dataset
})


# Test the range of 'VIX_Detail' values
test_that("VIX Detail values are within expected range", {
  expect_true(all(vix_data$VIX_Detail > -100 & vix_data$VIX_Detail < 100))
})

# Test for the presence of NA values in the VIX dataset
test_that("No NA values are present in the VIX dataset", {
  expect_true(all(complete.cases(vix_data)))
})

# Test the correlation expectation between 'Residuals_Detail' and 'VIX_Detail'
test_that("Correlation between Residuals Detail and VIX Detail meets expectation", {
  correlation <- cor(residuals_data$Residuals_Detail, vix_data$VIX_Detail)
  expect_true(correlation < 0, info = "Expecting a negative correlation as per the analysis findings")
})
