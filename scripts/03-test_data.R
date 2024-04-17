#### Preamble ####
# Purpose: Tests the cleaned dataset
# Author: Carl Fernandes, Lexi knight, Raghav Bhatia 
# Date: 12 March 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Test data ####

#### Reads the cleaned dataset 

ces2020_data <- read_parquet("data/cleaned_data/ces2020_cleaned/part-0.parquet")

# Test if the dataset has 100 entries
test_that("Dataset has 100 entries", {
  expect_equal(nrow(ces2020_data), 39203)
})

# Test if 'gender' only contains 'Male' and 'Female'
test_that("Gender variable is correct", {
  expect_true(all(ces2020_data$gender %in% c('Male', 'Female')))
})

# Test if 'education' contains the correct levels
test_that("Education variable is correct", {
  expect_true(all(ces2020_data$education %in% c('No HS', 'High school graduate', 'Some college', '2-year', '4-year', 'Post-grad')))
})

# Test if 'race' contains the correct categories
test_that("Race variable is correct", {
  expect_true(all(ces2020_data$race %in% c('White', 'Black', 'Hispanic', 'Asian', 'Native American', 'Middle Eastern', 'Two or more races')))
})

# Test if 'national_economics' contains the correct categories
test_that("National Economics variable is correct", {
  expect_true(all(ces2020_data$economic_outlook %in% c('Gotten much better', 'Gotten somewhat better', 'Stayed about the same', 'Gotten somewhat worse', 'Gotten much worse', 'Not sure')))
})

# Test if 'household_income' contains the correct categories
test_that("Household Income variable is correct", {
  expect_true(all(ces2020_data$income_change %in% c('Increased a lot', 'Increased somewhat', 'Stayed about the same', 'Decreased somewhat', 'Decreased a lot')))
})
