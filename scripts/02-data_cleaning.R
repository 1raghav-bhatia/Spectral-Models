#### Preamble ####
# Purpose: Cleans the raw elections data for a few select demographic and 
# economic variables.
# Author: Carl Fernandes, Lexi Knight and Raghav Bhatia
# Date: 12 March 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the raw data downloaded beforehand.

#### Workspace setup ####
library(tidyverse)
library(readr)
library(arrow)

#### Clean data ####

### Reading Data

## Reading the demographic data from the raw data folder with the appropriate column types

ces2020_demographic_raw <-
  read_csv(
    "data/raw_data/ces2020_demographic_data.csv",
    col_types =
      cols(
        votereg = col_integer(),
        CC20_410 = col_integer(),
        gender = col_integer(),
        educ = col_integer(),
        race = col_integer(), 
        martstat = col_integer(), 
        region = col_integer(), 
        faminc_new = col_character()
      )
  )

## Reading the economic data from the raw data folder with the appropriate column types

ces2020_economic_raw <-
  read_csv(
    "data/raw_data/ces2020_economic_data.csv",
    col_types =
      cols(
        votereg = col_integer(),
        CC20_410 = col_integer(),
        CC20_302 = col_integer(),
        CC20_303 = col_integer()
      )
  )

### Modifying the Data

## Now we change the column names and their integer values to reflect their actual
## text responses.

# We clean the demographic data now by selecting registered voters, those who only
# voted for either trump or biden, and changing the integer values to their
# text counterparts.

ces2020_demographic_cleaned <-
  ces2020_demographic_raw |>
  filter(votereg == 1, CC20_410 %in% c(1, 2)) |>
  mutate(
    voted_for = if_else(CC20_410 == 1, "Biden", "Trump"),
    voted_for = as_factor(voted_for),
    gender = if_else(gender == 1, "Male", "Female"),
    education = case_when(
      educ == 1 ~ "No HS",
      educ == 2 ~ "High school graduate",
      educ == 3 ~ "Some college",
      educ == 4 ~ "2-year",
      educ == 5 ~ "4-year",
      educ == 6 ~ "Post-grad"
    ),
    education = factor(education, levels = c("No HS", "High school graduate", 
                                             "Some college", "2-year", "4-year", 
                                             "Post-grad")),
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "Hispanic",
      race == 4 ~ "Asian",
      race == 5 ~ "Native American",
      race == 6 ~ "Middle Eastern",
      race == 7 ~ "Two or more races",
      TRUE ~ NA_character_
    ),
    race = as_factor(race),
    region = case_when(
      region == 1 ~ "Northeast",
      region == 2 ~ "Midwest",
      region == 3 ~ "South",
      region == 4 ~ "West"
    ),
    region = as_factor(region),
    marriage_status = case_when(
      marstat == 1 ~ "Married",
      marstat == 2 ~ "Separated",
      marstat == 3 ~ "Divorced",
      marstat == 4 ~ "Widowed",
      marstat == 5 ~ "Never married",
      marstat == 6 ~ "Domestic/civil partnership"
    ),
    marriage_status = as_factor(marriage_status),
    family_income = case_when(
      faminc_new == 1 ~ "Less than $10,000",
      faminc_new == 2 ~ "$10,000 - $19,999",
      faminc_new == 3 ~ "$20,000 - $29,999",
      faminc_new == 4 ~ "$30,000 - $39,999",
      faminc_new == 5 ~ "$40,000 - $49,999",
      faminc_new == 6 ~ "$50,000 - $59,999",
      faminc_new == 7 ~ "$60,000 - $69,999",
      faminc_new == 8 ~ "$70,000 - $79,999",
      faminc_new == 9 ~ "$80,000 - $99,999",
      faminc_new == 10 ~ "$100,000 - $119,999",
      faminc_new == 11 ~ "$120,000 - $149,999",
      faminc_new == 12 ~ "$150,000 - $199,999",
      faminc_new == 13 ~ "$200,000 - $249,999",
      faminc_new == 14 ~ "$250,000 - $349,999",
      faminc_new == 15 ~ "$350,000 - $499,999",
      faminc_new == 16 ~ "$500,000 or more",
      faminc_new == 17 ~ "Prefer not to say",
      TRUE ~ NA_character_
    ),
    family_income = factor(family_income, levels = c(
                                                      "Less than $10,000",
                                                      "$10,000 - $19,999",
                                                      "$20,000 - $29,999",
                                                      "$30,000 - $39,999",
                                                      "$40,000 - $49,999",
                                                      "$50,000 - $59,999",
                                                      "$60,000 - $69,999",
                                                      "$70,000 - $79,999",
                                                      "$80,000 - $99,999",
                                                      "$100,000 - $119,999",
                                                      "$120,000 - $149,999",
                                                      "$150,000 - $199,999",
                                                      "$200,000 - $249,999",
                                                      "$250,000 - $349,999",
                                                      "$350,000 - $499,999",
                                                      "$500,000 or more",
                                                      "Prefer not to say"
                                                      )
                           )
  ) |>
  select(voted_for, gender, education, race, region, marriage_status, family_income)

# We clean the economic data now by selecting registered voters, those who only
# voted for either trump or biden, and changing the integer values to their
# text counterparts.

cces2020_economic_cleaned <-
  ces2020_economic_raw |>
  filter(votereg == 1, CC20_410 %in% c(1, 2)) |>
  mutate(
    voted_for = if_else(CC20_410 == 1, "Biden", "Trump"),
    voted_for = as_factor(voted_for),
    economic_outlook = case_when(
      CC20_302 == 1 ~ "Gotten much better",
      CC20_302 == 2 ~ "Gotten somewhat better",
      CC20_302 == 3 ~ "Stayed about the same",
      CC20_302 == 4 ~ "Gotten somewhat worse",
      CC20_302 == 5 ~ "Gotten much worse",
      CC20_302 == 6 ~ "Not sure",
      TRUE ~ NA_character_
    ),
    economic_outlook = factor(economic_outlook, levels = c(
                                                           "Gotten much better",
                                                           "Gotten somewhat better",
                                                           "Stayed about the same",
                                                           "Gotten somewhat worse",
                                                           "Gotten much worse",
                                                           "Not sure"
                                                           )
                              ),
    income_change = case_when(
      CC20_303 == 1 ~ "Increased a lot",
      CC20_303 == 2 ~ "Increased somewhat",
      CC20_303 == 3 ~ "Stayed about the same",
      CC20_303 == 4 ~ "Decreased somewhat",
      CC20_303 == 5 ~ "Decreased a lot",
      TRUE ~ NA_character_
    ),
    income_change = factor(income_change, levels = c(
                                                     "Increased a lot",
                                                     "Increased somewhat",
                                                     "Stayed about the same",
                                                     "Decreased somewhat",
                                                     "Decreased a lot",
                                                     "Other"))
  ) |>
  select(economic_outlook, income_change)

### Combining the Datasets

## We now combine both the datasets and drop all the missing data rows. We drop
## the missing data values because they are only 10% of our dataset with the bulk
## being income data. Since the income data for out purposes is MAR, we can drop 
## the data.

ces2020_full_cleaned <- cbind(ces2020, ces2020_income_effect)
ces2020_full_cleaned <- ces2020_full_cleaned |> drop_na()

#### Save data ####
write_dataset(ces2020_full_cleaned, "data/cleaned_data/ces2020_cleaned",
              format = "parquet")

