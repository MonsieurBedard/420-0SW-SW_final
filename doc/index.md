# Documentation projet final

## Description

Création d'un jeux de course à la 3eme personne avec un générateur de piste aléatoire.

Utilisation de Godot + GDScript.

## Outils utilisés

- Utilisation de Godot comme game engine.
- Utilisation de GDScript dans Godot comme langage de programmation.
- Utilisation de la [documentation officiel de godot](https://docs.godotengine.org/en/stable/) sur le web et dans l'éditeur.
- Utilisation de [Aseprite](https://www.aseprite.org/) pour les assets.

## Références

[Inspiration pour la création de piste:](https://www.gamasutra.com/blogs/GustavoMaciel/20131229/207833/Generating_Procedural_Racetracks.php)

- Inspiration principal afin de concevoir le générateur de piste et de l'adapter dans godot.

[Wikipedia - Convex hull:](https://en.wikipedia.org/wiki/Convex_hull)

- Utiliser dans la génération du périmètre de la piste.
- Permet de trouver l'enveloppe convexe d'un regroupement de points.

[Wikipedia - Jarvis march:](https://en.wikipedia.org/wiki/Gift_wrapping_algorithm)

- Utiliser dans la génération du périmètre de la piste.
- Algorithme utiliser afin de trouver l'enveloppe convexe.

[Wikipedia - A\* search algorithm:](https://en.wikipedia.org/wiki/A*_search_algorithm)

- Utiliser dans la génération du périmètre de la piste.
- Permet de relier les points obtenues avec la marche de jarvis afin de pouvoir créer un circuit complet autour du périmètre.

[Godot doc - GDScript basics](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html)

- Document contenant les informations de bases sur le GDScript.

[Godot doc - Utiliser les palettes de tuiles](https://docs.godotengine.org/fr/stable/tutorials/2d/using_tilemaps.html)

- Utilisation afin de pouvoir utiliser la TileMap dans Godot.

[Youtube - Godot Recipes: Car Steering:](https://youtu.be/mJ1ZfGDTMCY)

- Utiliser afin de définir la physique des véhicules dans le jeux.

[Youtube - AutoTiles OpenSimplex Noise Procedural Generation Godot 3.1 Tutorial](https://youtu.be/SBDs8hbs43w)

- Tutoriel afin de pouvoir utiliser les TileMap dans godot.

[Youtube - Godot One Shot: TileMap Collisions](https://youtu.be/OzgK__VowVs)

- Tutoriel pour les collisions avec un TileMap. (Pas utiliser au moment de la présentation)

[Youtube - Design and Code a Title Screen in Godot 3 (tutorial)](https://youtu.be/sKuM5AzK-uA)

- Tutoriel afin de créer un menu de base dans godot.

[Youtube - How to Code a Pause in Godot (tutorial)](https://youtu.be/Jf7F3JhY9Fg)

- Tutoriel afin de faire la création d'un menu de pause et pour faire l'arrêt temporaire de la physique du jeux.

[Youtube - My Tileset Workflow (Pixel Art & Gamedev Tutorial)](https://youtu.be/btnH0x7_1g8)

- Tutoriel afin de pouvoir faire la création d'un TileSet dans Aseprite.
