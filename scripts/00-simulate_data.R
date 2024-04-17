#### Preamble ####
# Purpose: Simulates the clean dataset used in the for the model.
# Author: Carl Fernandes, Lexi knight, Raghav Bhatia 
# Date: 12 March 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Simulate data ####
set.seed(0) 
# for reproducibility

# Number of entries
num_entries <- 100

# Simulating the data
simulated_data <- data.frame(
  votereg = sample(c(1, 2), num_entries, replace = TRUE, prob = c(0.9, 0.1)),
  voted_for = sample(c("Biden", "Trump"), num_entries, replace = TRUE, prob = c(0.5, 0.5)),
  gender = sample(c("Male", "Female"), num_entries, replace = TRUE, prob = c(0.48, 0.52)),
  education = sample(c("No HS", "High school graduate", "Some college", "2-year", "4-year", "Post-grad"), num_entries, replace = TRUE),
  race = sample(c("White", "Black", "Hispanic", "Asian", "Native American", "Middle Eastern", "Two or more races"), num_entries, replace = TRUE),
  economic_outlook = sample(c("Gotten much better", "Gotten somewhat better", "Stayed about the same", "Gotten somewhat worse", "Gotten much worse", "Not sure"), num_entries, replace = TRUE),
  income_change = sample(c("Increased a lot", "Increased somewhat", "Stayed about the same", "Decreased somewhat", "Decreased a lot"), num_entries, replace = TRUE)
) |> filter(votereg == 1)

simulated_data <- simulated_data |> select(voted_for, gender, education, race,
                                           economic_outlook, income_change)

# Viewing the first few rows of the simulated data
head(simulated_data)

# Testing the simulated table

# Test if the dataset has 100 entries
test_that("Dataset has 100 entries", {
  expect_equal(nrow(simulated_data), 100)
})

# Test if 'gender' only contains 'Male' and 'Female'
test_that("Gender variable is correct", {
  expect_true(all(simulated_data$gender %in% c('Male', 'Female')))
})

# Test if 'education' contains the correct levels
test_that("Education variable is correct", {
  expect_true(all(simulated_data$education %in% c('No HS', 'High school graduate', 'Some college', '2-year', '4-year', 'Post-grad')))
})

# Test if 'race' contains the correct categories
test_that("Race variable is correct", {
  expect_true(all(simulated_data$race %in% c('White', 'Black', 'Hispanic', 'Asian', 'Native American', 'Middle Eastern', 'Two or more races')))
})

# Test if 'national_economics' contains the correct categories
test_that("National Economics variable is correct", {
  expect_true(all(simulated_data$economic_outlook %in% c('Gotten much better', 'Gotten somewhat better', 'Stayed about the same', 'Gotten somewhat worse', 'Gotten much worse', 'Not sure')))
})

# Test if 'household_income' contains the correct categories
test_that("Household Income variable is correct", {
  expect_true(all(simulated_data$income_change %in% c('Increased a lot', 'Increased somewhat', 'Stayed about the same', 'Decreased somewhat', 'Decreased a lot')))
})



