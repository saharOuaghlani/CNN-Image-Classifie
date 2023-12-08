# CNN-Image-Classifier
Ce projet vise à construire un modèle d'apprentissage destiné à la classification d'images de poumons en trois catégories distinctes : COVID, NORMAL et PNEUMONIA. Pour ce faire, une base de données d'images prétraitées et redimensionnées à 256x256 pixels au format PNG est mise à disposition. L'objectif final est de développer une interface graphique permettant de tester différentes images afin d'évaluer la pertinence du système.

Résumé des Étapes :
# 1- Définition de l’architecture du modèle CNN (Réseau de Neurones Convolutifs) :
Choix du nombre de couches convolutives.
Sélection des fonctions d'activation pour chaque couche.
Détermination du nombre d'unités cachées pour chaque couche.
Entraînement du Modèle :

# 2- Division de la base de données en images d'entraînement avec leurs étiquettes et images de test avec leurs étiquettes correspondantes.
Définition du nombre d'époques pour l'entraînement.
Lancement de l'entraînement du modèle.

# 3- Prédiction des Images :
Chargement des données de test (images).
Prédiction des classes pour ces images à l'aide du modèle entraîné.

# 4- Estimation des Performances du Modèle :
Génération d'une matrice de confusion pour évaluer la performance du modèle.
Affichage de la précision (accuracy) du modèle.
