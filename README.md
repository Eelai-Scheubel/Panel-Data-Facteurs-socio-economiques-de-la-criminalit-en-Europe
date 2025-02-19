# Panel-Data-Socioeconomic-Factors-of-Crime-in-Europe

## Project Description
This project analyzes the socio-economic determinants of crime in Europe, highlighting the impact of unemployment and social policies on homicide rates. The study is conducted using an econometric model based on panel data covering 22 European countries from 2011 to 2019.

## Methodology
The analysis is based on econometric models with different specifications:
- **OLS Regression Model** (Ordinary Least Squares)
- **Fixed Effects Model**
- **Random Effects Model**

The data used comes from reputable sources such as the World Bank, OECD, UN, and Eurostat.

## Data and Variables
- **Dependent Variable**: Homicide rate (per 100,000 inhabitants)
- **Explanatory Variables**:
  - GDP per capita
  - Unemployment rate
  - Gini coefficient (income inequality)
  - Social spending (% of GDP)
  - Education spending (% of GDP)
  - Urbanization rate
  - Immigration flow
  - Democracy index
  - Interaction effect (Moderating effect of social spending on the impact of unemployment)

## Installation and Usage
### Prerequisites
Make sure you have R installed with the following libraries:
- jsonlite
- readxl
- dplyr
- tidyr
- plm
- corrplot
- lmtest
- sandwich
- stargazer
- AER

The study's key findings include:
- **Unemployment and Crime**: A significant positive relationship between the unemployment rate and homicide rate, indicating that higher unemployment is associated with increased crime levels.
- **Social Spending as a Buffer**: The interaction term between unemployment and social spending is significant and negative, suggesting that higher social spending mitigates the impact of unemployment on crime.
- **No Significant Effect of GDP**: Unlike some previous studies, GDP per capita does not appear to have a strong direct influence on homicide rates.
- **Democracy and Crime**: A higher democracy index is weakly linked with lower crime rates, but this relationship requires further study.
- **No Link Between Immigration and Crime**: The analysis does not support the hypothesis of a significant relationship between immigration levels and crime rates.

- Visualization of correlations and fixed effects by country
