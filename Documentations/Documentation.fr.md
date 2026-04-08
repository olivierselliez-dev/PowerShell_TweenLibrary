# Documentation : Bibliothèque d'Animation PowerShell (Tweens)

Cette bibliothèque permet d'intégrer des animations fluides dans des interfaces **Windows Forms**.

## Architecture

- **Tweens.ps1** : Définition des classes (`TweenMoveTo`, `TweenColorARGB`, etc.).
- **TweensUpdater.ps1** : Moteur de rendu (Boucle Update).
- **TweensVariables.ps1** : Constantes d'Easing.

## Utilisation Rapide

1. Initialisez la liste globale :
   ```powershell
   $Script:listToAnimate = New-Object System.Collections.ArrayList
   ```

2. Créez une animation :
   ```powershell
   $anim = [TweenMoveTo]::new($monControle, $destination, $dureeSec, $typeEasing)
   $Script:listToAnimate.Add($anim)
   ```

## Classes Disponibles

### TweenMoveTo
Anime la position `Location` d'un contrôle.
- **Paramètres** : `Control`, `Point` (Destination), `Double` (Durée), `String` (Easing).

### TweenColorARGB
Transitionne entre deux couleurs (`ForeColor` ou `BackColor`).
- **Paramètres** : `Control`, `String` (Propriété), `Color` (Start), `Color` (End), `Double` (Durée), `String` (Easing).

### TweenNumericString
Anime une valeur numérique dans le texte d'un label.
- **Paramètres** : `Control`, `String` (Type: int/double), `Double` (Start), `Double` (End), `Double` (Durée), `String` (Easing).

### TweenProgressBar
Anime la progression d'une `ProgressBar`.
- **Paramètres** : `ProgressBar`, `Double` (Start), `Double` (End), `Double` (Durée), `String` (Easing).

## Easing (Atténuation)

Les variables d'atténuation sont accessibles via le scope `$Script:` (ex: `$Script:easeBounceOut`).
Principaux types :
- `Linear`
- `Expo`
- `Bounce`
- `Elastic`
- `Back`

## Performances

Le moteur tourne par défaut à 60 FPS (`$Script:refreshRate = 60`).

> **Note importante** : Assurez-vous que le timer est correctement disposé à la fermeture du formulaire :
> ```powershell
> $mainForm.Add_Closing({ $timer.Dispose() })
> ```

---
*Documentation générée pour le projet Tweens PowerShell.*