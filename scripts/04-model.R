#### Preamble ####
# Purpose: To model the relationship between short-term market fluctuations and VIX.
# Author: Raghav Bhatia
# Date: 16 April 2024
# Contact: raghav.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the cleaned dataset of detailed coefficients.

#### Workspace setup ####
library(rstanarm)
library(broom)
library(broom.mixed)
library(modelsummary)
library(arrow)
library(ggplot2)

#### Read data ####
detailed_coefficient_vix <- 
  arrow::read_parquet("data/cleaned_data/detail_coefficients_vix.parquet")
detailed_coeffs_mkt_shocks <- 
  arrow::read_parquet("data/cleaned_data/detail_coefficients_market_shock.parquet")
detailed_coeffs_df <- 
  cbind(detailed_coefficient_vix[1:185,], detailed_coeffs_mkt_shocks[1:185,])

### Mathematical Model ###

## \begin{align*}
##  y_i &\sim N(\mu_i, \sigma^2) \\
##  \mu_i &= \beta_0 + \beta_1 \cdot \text{Market\_Return\_Detail}_i \\
##  \beta_0 &\sim N(0, 10) \\
##  \beta_1 &\sim N(0, 10) \\
##  \sigma &\sim \text{Exponential}(1)
## \end{align*}

### Model data ####

## GLM for VIX based on Market Return Details
market_shock_regression <- stan_glm(
  VIX_Detail ~ Market_Return_Detail,
  data = detailed_coeffs_df, 
  family = gaussian(),  # Assuming normal distribution of errors
  prior = normal(0, autoscale = TRUE),  # Normal prior with autoscaling
  chains = 4, iter = 2000
)

## Summary and diagnostics
summary(market_shock_regression)
modelsummary(market_shock_regression)

## Plot results
p <- ggplot(detailed_coeffs_df, aes(x = Market_Return_Detail, y = VIX_Detail)) +
  geom_point(alpha = 0.6, color = "blue", size = 3) +
  geom_smooth(method = "glm", method.args = list(family = gaussian()), 
              se = TRUE, color = "red", fill = "pink") +
  labs(title = "Regression of VIX on Market Return Details",
       x = "Market Return Detail Coefficients",
       y = "VIX Detail Coefficients",
       caption = "Data Source: Detailed Coefficients from Financial Models") +
  theme_minimal() +
  theme(text = element_text(size = 12),
        plot.title = element_text(face = "bold", hjust = 0.5),
        plot.caption = element_text(hjust = 0, color = "grey50"))

print(p)

#### Save model ####
saveRDS(market_shock_regression, file = "models/market_shock_regression.rds")



