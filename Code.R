library(jsonlite)
library(readxl)
library(dplyr)
library(tidyr)
library(plm)
library(corrplot)
library(lmtest)
library(sandwich)
library(stargazer)
library(AER)


# Liste des pays
defined_countries <- c("Austria", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy",
                       "Lithuania", "Luxembourg", "Netherlands", "Norway", "Poland", "Portugal", "Slovak Republic", "Slovakia", 
                       "Slovenia", "Spain", "Sweden", "Switzerland", "United Kingdom")

# Fonction de chargement et filtrage des données
load_and_filter_data <- function(url, year_col = "Year", country_col = "Entity") {
  data <- read.csv(url)
  data <- data %>% filter(!!sym(country_col) %in% defined_countries, !!sym(year_col) >= 2011, !!sym(year_col) <= 2019)
  select(data, -c(2))
}

load_excel_data <- function(file_path) {
  data <- read_excel(file_path) %>%
    mutate(across(starts_with("20"), as.numeric)) %>%
    pivot_longer(cols = starts_with("20"), names_to = "Year", values_to = "Values") %>%
    filter(Entity %in% defined_countries, Year >= 2011, Year <= 2019)
  return(data)
}

# Chargement des datasets
gini <- load_and_filter_data("https://ourworldindata.org/grapher/economic-inequality-gini-index.csv?v=1&csvType=full")
gdp <- load_and_filter_data("https://ourworldindata.org/grapher/gdp-per-capita-worldbank.csv?v=1&csvType=full")
unemp <- load_and_filter_data("https://ourworldindata.org/grapher/unemployment-rate.csv?v=1&csvType=full")
education <- load_and_filter_data("https://ourworldindata.org/grapher/total-government-expenditure-on-education-gdp.csv?v=1&csvType=full")
homicide <- load_and_filter_data("https://ourworldindata.org/grapher/homicide-rate-unodc.csv?v=1&csvType=full")
urban <- load_and_filter_data("https://ourworldindata.org/grapher/urban-population-share-2050.csv?v=1&csvType=full")
democracy <- load_and_filter_data("https://ourworldindata.org/grapher/democracy-index-eiu.csv?v=1&csvType=full")
pss <- load_excel_data("social expenditure oecd.xlsx")
immigration <- load_excel_data("Immigration.xlsx")

# Fusion des données
df <- cbind(homicide, gdp[, 3], unemp[, 3], gini[, 3], pss[, 3], education[, 3], urban[, 3], immigration[, 3], democracy[, 3])
colnames(df) <- c("Country", "Year", "homicide", "GDPpc", "unemp", "gini", "pss", "educ", "urban", "immigration", "democracy")
df_panel <- pdata.frame(df, index = c("Country", "Year"))

# Corrélation
display_correlation_matrix <- function(data) {
  cor_matrix <- cor(data[, c("GDPpc", "urban", "gini", "unemp", "pss", "educ", "immigration", "democracy")], use = "pairwise.complete.obs")
  corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45, addCoef.col = "black", number.cex = 0.7)
  return(cor_matrix)
}

cor_matrix <- display_correlation_matrix(df_panel)



# Statistiques descriptives
df_summary <- summary(df)
sd_values <- sapply(df, function(x) if(is.numeric(x)) sd(x) else NA)

# Modèle MCO et tests statistiques
ols <- lm(homicide ~ GDPpc + unemp + gini + pss + educ + urban + immigration + democracy + pss * unemp, data = df_panel)
summary(ols)
bptest(ols)
robust_ols <- coeftest(ols, vcovHC(ols, method = "arellano"))

# Tests sur les effets
pFtest(homicide~GDPpc+unemp+gini+pss+educ+urban+immigration+democracy+pss*unemp, data=df_panel, effect ="indiv")
pFtest(homicide~GDPpc+unemp+gini+pss+educ+urban+immigration+democracy+pss*unemp, data=df_panel, effect ="time")
pFtest(homicide~GDPpc+unemp+gini+pss+educ+urban+immigration+democracy+pss*unemp, data=df_panel, effect ="twoway")

plmtest(homicide~GDPpc+unemp+gini+pss+educ+urban+immigration+democracy+pss*unemp, data=df_panel, effect="indiv", type ="bp")
plmtest(homicide~GDPpc+unemp+gini+pss+educ+urban+immigration+democracy+pss*unemp, data=df_panel, effect="time", type ="bp")
plmtest(homicide~GDPpc+unemp+gini+pss+educ+urban+immigration+democracy+pss*unemp, data=df_panel, effect="twoway", type ="bp")


# Modèles des effets fixes (Within) et tests statistiques
fe_model <- plm(homicide ~ GDPpc + unemp + gini + pss + educ + urban + immigration + democracy + pss * unemp, 
                data = df_panel, model = "within", effect = "individual")
summary(fe_model)
pdwtest(fe_model, data = df_panel, model = "within")  # Autocorrélation
bptest(fe_model, studentize = FALSE)  # Hétéroscédasticité
robust_fe <- coeftest(fe_model, vcovHC(fe_model, method = "arellano"))

# Modèles des effets aléatoires et tests statistiques
re_model <- plm(homicide ~ GDPpc + unemp + gini + pss + educ + urban + immigration + democracy + pss * unemp, 
                data = df_panel, model = "random", effect = "individual")
summary(re_model)
pdwtest(re_model, data = df_panel, model = "random")
bptest(re_model, studentize = FALSE)
robust_re <- coeftest(re_model, vcovHC(re_model, method = "arellano"))

# Test d'Hausman
hausman_test <- phtest(fe_model, re_model, vcov = list(robust_fe, robust_re))

# Statistiques des modèles
stats <- list(
  n_obs = nrow(df_panel),
  r2_ols = summary(ols)$r.squared,
  r2_fixed = summary(fe_model)$r.squared[1],
  r2_random = summary(re_model)$r.squared[1],
  adj_r2_ols = summary(ols)$adj.r.squared
)

# Tableau de comparaison des modèles
stargazer(robust_ols, robust_fe, robust_re, type = "text",
          title = "Estimation Results",
          column.labels = c("OLS", "Within", "GLS"),
          covariate.labels = c("GDP per capita", "Unemployment rate", "Gini index", "Public social spending", 
                               "Public education spending", "Urbanization rate", "Immigration", "Democracy index", 
                               "Unemployment * Public social spending"),
          dep.var.labels = "Annual homicide rate (per 100,000 people)",
          digits = 3,
          add.lines = list(
            c("Number of observations", stats$n_obs, stats$n_obs, stats$n_obs),
            c("R²", round(stats$r2_ols, 3), round(stats$r2_fixed, 3), round(stats$r2_random, 3)),
            c("Adjusted R²", round(stats$adj_r2_ols, 3), "", "")
          )
)

# Effets fixes individuels
fe_ind <- fixef(fe_model, effect = "individual")
df_fe_ind <- data.frame(Individual = names(fe_ind), Fixed_Effect = as.numeric(fe_ind))

stargazer(df_fe_ind, type = "html",
          title = "Estimated Fixed Effects")

