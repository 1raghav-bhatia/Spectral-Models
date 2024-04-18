#### Preamble ####
# Purpose: Simulates the clean dataset used for the model, focusing on residual and VIX detail coefficients.
# Author: Raghav Bhatia 
# Date: 16 April 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Simulate data ####
set.seed(100) 

# Number of entries
num_entries <- 185

# Simulating the data
simulated_data <- tibble(
  Market_Return_Detail = rnorm(num_entries, mean = 0, sd = 2),  # Assuming normal distribution
  VIX_Detail = rnorm(num_entries, mean = 0, sd = 2) + 0.5 * Market_Return_Detail  # Including some dependency
)

# Viewing the first few rows of the simulated data
head(simulated_data)

# Testing the simulated table

# Test if the dataset has 100 entries
test_that("Dataset has 100 entries", {
  expect_equal(nrow(simulated_data), 185)
})

# Test if Market Return Detail values are within expected range
test_that("Market Return Detail values are normally distributed", {
  expect_true(all(simulated_data$Market_Return_Detail < 10 & simulated_data$Market_Return_Detail > -10))
})

# Test if VIX Detail values are within expected range
test_that("VIX Detail values are normally distributed", {
  expect_true(all(simulated_data$VIX_Detail < 10 & simulated_data$VIX_Detail > -10))
})

# Test the correlation between Market Return Detail and VIX Detail
test_that("Correlation between Market Return Detail and VIX Detail is positive", {
  expect_true(cor(simulated_data$Market_Return_Detail, simulated_data$VIX_Detail) > 0)
})


