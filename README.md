# Facteurs Socioéconomiques du Crime en Europe – Données de Panel

## Description du Projet  
Ce projet analyse les déterminants socio-économiques du crime en Europe, en mettant en évidence l'impact du chômage et des politiques sociales sur les taux d’homicide. L’étude est réalisée à l’aide d’un modèle économétrique basé sur des données de panel couvrant 22 pays européens entre 2011 et 2019.  

## Méthodologie  
L’analyse repose sur des modèles économétriques avec différentes spécifications :  
- **Régression par Moindres Carrés Ordinaires (MCO)**  
- **Modèle à Effets Fixes**  
- **Modèle à Effets Aléatoires**  

Les données utilisées proviennent de sources reconnues telles que la Banque mondiale, l’OCDE, l’ONU et Eurostat.  

## Données et Variables  
### Variable dépendante  
- Taux d’homicide (pour 100 000 habitants)  

### Variables explicatives  
- PIB par habitant  
- Taux de chômage  
- Coefficient de Gini (inégalités de revenu)  
- Dépenses sociales (% du PIB)  
- Dépenses en éducation (% du PIB)  
- Taux d’urbanisation  
- Flux migratoires  
- Indice de démocratie  
- Effet d’interaction (Effet modérateur des dépenses sociales sur l’impact du chômage)  

## Installation et Utilisation  
### Prérequis  
Assurez-vous d’avoir R installé avec les bibliothèques suivantes :  
- `jsonlite`  
- `readxl`  
- `dplyr`  
- `tidyr`  
- `plm`  
- `corrplot`  
- `lmtest`  
- `sandwich`  
- `stargazer`  
- `AER`  

## Principaux Résultats de l’Étude  
- **Chômage et Criminalité** : Une relation positive et significative entre le taux de chômage et le taux d’homicide, indiquant qu’un chômage plus élevé est associé à une augmentation de la criminalité.  
- **Les dépenses sociales comme effet modérateur** : Le terme d’interaction entre le chômage et les dépenses sociales est significatif et négatif, suggérant que des dépenses sociales plus élevées atténuent l’impact du chômage sur la criminalité.  
- **Aucun effet significatif du PIB par habitant** : Contrairement à certaines études précédentes, le PIB par habitant ne semble pas avoir une influence directe sur les taux d’homicide.  
- **Démocratie et Criminalité** : Un indice de démocratie plus élevé est faiblement lié à des taux de criminalité plus bas, mais cette relation mérite une analyse plus approfondie.  
- **Aucun lien entre Immigration et Criminalité** : L’analyse ne soutient pas l’hypothèse d’une relation significative entre les niveaux d’immigration et les taux de criminalité.  

## Visualisation  
- Corrélations entre variables  
- Effets fixes par pays  
