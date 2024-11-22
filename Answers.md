# Answers

## 1 - Environnement

## Exercice 1

### Les targets
Ce sont des configurations dans Xcode qui permettent de définir pour quel appareil ou plateforme on compile l'application.

### Les fichiers de base
Ce sont des fichiers automatiques créés par Xcode quand on lance un projet, comme les paramètres de compilation et les ressources nécessaires.

### Le dossier Assets.xcassets
C'est un dossier où on met toutes les images, icônes et autres ressources visuelles qu'on utilise dans l'app.

### Ouvrir le storyboard
Le storyboard est un fichier qui permet de créer l'interface de l'app en plaçant des écrans et en définissant comment ils se relient entre eux.

### Ouvrir un simulateur
Le simulateur permet de tester l'application sur un appareil virtuel (comme un iPhone ou un iPad) sans avoir besoin d'un vrai appareil.

## Exercice 2

- Cmd + R : Lance l'application.
- Cmd + Shift + O : Recherche un fichier.
- Indenter automatiquement : Ctrl + I.
- Commenter la sélection : Cmd + /.

## 3 - Délégation

## Exercice 1

Une propriété statique partage une valeur entre toutes les instances d'une classe.

## 4 - Navigation

## Exercice 1

On vient de configurer un NavigationController, qui gère la navigation entre les vues en les empilant et dépilant.

Le NavigationController gère la logique de navigation, tandis que la NavigationBar est l'élément visuel en haut de l'écran (titre, boutons).

## 6 - Ecran Detail

## Exercice 1

Un Segue permet de naviguer d'un écran à un autre dans une app iOS.

## Exercice 2

Une constraint est une règle qui détermine la position et la taille des éléments sur l'écran. Elle sert à créer des interfaces flexibles avec AutoLayout, pour que l'UI s'adapte à différentes tailles d'écran.

## 9 - QLPreview

Changer l'accessory pour un disclosureIndicator rend l'interface plus claire, plus cohérente avec les conventions de la plateforme, et indique facilement à l'utilisateur qu'il peut interagir avec l'élément.

## 10 - Importation

selector en Swift permet de référencer une méthode à appeler lors d'un événement, comme un clic sur un bouton.

.add correspond à une valuer de l'enumération requise en paramètre.

@objc est nécessaire pour rendre la méthode compatible avec le runtime Objective-C, requis pour le #selector.

Oui, on peut ajouter plusieurs boutons dans la barre de navigation en utilisant navigationItem.rightBarButtonItems et en lui assigant un tableau de UIBarButtonItem par exemple.

```swift
let button1 = UIBarButtonItem(title: "Button 1", style: .plain, target: self, action: #selector(button1Tapped))
let button2 = UIBarButtonItem(title: "Button 2", style: .plain, target: self, action: #selector(button2Tapped))

navigationItem.rightBarButtonItems = [button1, button2]
```

Defer permet d'executer le code à l'interieur du block à la fin de la methode.
