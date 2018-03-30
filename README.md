# GraceTHD-Labo

Destiné à accueillir des projets d'extension de GraceTHD-MCD. 
http://gracethd.org

**Attention, les élements contenus ici sont expérimentaux, destinés à des utilisateurs qui ont la capacité d'analyser et de contribuer au code. N'utilisez cela que si vous savez ce que vous faites !**

## Fonctionnement : 
Un dossier par projet d'extension du modèle de données. Exemple "Enedis". Le niveau 2 de l'arborescence doit être compatible avec l'arborescence GraceTHD-Check. Chaque sous-projet GraceTHD-Labo doit comporter un dossier ./docs/GraceTHD-Labo/[sous-projet]/ et une rapide documentation de ce sous-projet. 

Globalement il suffit : 
- soit d'exécuter directement le contenu des fichiers SQL à disposition sur une base de données de test. 
- soit d'intégrer le contenu d'un de ces fichiers SQL directement dans le fichier gracethd_90_labo.sql de son GraceTHD-Check. 

Les fichiers SQL comportent des commentaires permettant de comprendre les usages. 

## Les labos

### Constraints
Objectif : Produire de manière collaborative des ajouts "optionnels" de contraintes sur une base GraceTHD-MCD. 

Conception : 
https://redmine.gracethd.org/redmine/issues/431

Etat : initialisation. 

### Enedis
Objectif : production de récolés Enedis à partir de données GraceTHD.

Conception :
https://redmine.gracethd.org/redmine/issues/429

Etat : répond partiellement au besoin. Il semble que des différences entre les régions Enedis posent des limites. 

### Objects
Objectif : partager des vues objets. 

Conception : 
https://redmine.gracethd.org/redmine/issues/432

Etat : initialisé. Certains objets probablement exploitables. Exemples de vues objets : "itinéraires", conduites, plans de boite, plans de baie, ... 
