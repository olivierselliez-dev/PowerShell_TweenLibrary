# Documentation : Bibliothèque d'Animation PowerShell (Tweens)

Cette bibliothèque permet d'intégrer des animations fluides et performantes dans des interfaces **Windows Forms** en utilisant PowerShell.

## Sommaire
- [Architecture](#architecture)
- [Installation](#installation)
- [Utilisation Rapide](#utilisation-rapide)
- [Classes Disponibles](#classes-disponibles)
- [Easing (Atténuation)](#easing-atténuation)
- [Performances et Bonnes Pratiques](#performances)

## Architecture

- **Tweens.ps1** : Définition des classes (`TweenMoveTo`, `TweenColorARGB`, etc.).
- **TweensUpdater.ps1** : Moteur de rendu (Boucle Update).
- **TweensVariables.ps1** : Constantes mathématiques pour les courbes d'atténuation.

## Installation

Pour utiliser la bibliothèque, vous devez "dot-sourcer" les fichiers dans votre script principal :

```powershell
. "$PSScriptRoot\TweensVariables.ps1"
. "$PSScriptRoot\Tweens.ps1"
. "$PSScriptRoot\TweensUpdater.ps1"
```

## Utilisation Rapide

1. **Initialisation** : Créez la liste qui contiendra les animations actives.
   ```powershell
   $Script:listToAnimate = New-Object System.Collections.ArrayList
   ```

2. **Création** : Instanciez un objet Tween et ajoutez-le à la liste.
   ```powershell
   $destination = New-Object System.Drawing.Point(100, 100)
   $callback = { Write-Host "Animation terminée !" }
   $anim = [TweenMoveTo]::new($monControle, $destination, 0.5, $Script:easeOutExpo, $callback)
   $Script:listToAnimate.Add($anim)
   ```

## Classes Disponibles

### TweenMoveTo
Anime la position `Location` d'un contrôle.
- **Paramètres** : `Control`, `Point` (Destination), `Double` (Durée), `String` (Easing), `ScriptBlock` (Callback - Requis).

### TweenColorARGB
Transitionne entre deux couleurs (`ForeColor` ou `BackColor`).
- **Paramètres** : `Control`, `String` (Propriété), `Color` (Start), `Color` (End), `Double` (Durée), `String` (Easing), `ScriptBlock` (Callback - Requis).

### TweenNumericString
Anime une valeur numérique dans le texte d'un label.
- **Paramètres** : `Control`, `String` (Type: int/double), `Double` (Start), `Double` (End), `Double` (Durée), `String` (Easing), `ScriptBlock` (Callback - Requis).

### TweenProgressBar
Anime la progression d'une `ProgressBar`.
- **Paramètres** : `ProgressBar`, `Double` (Start), `Double` (End), `Double` (Durée), `String` (Easing), `ScriptBlock` (Callback - Requis).

## Easing (Atténuation)

Les variables d'atténuation sont accessibles via le scope `$Script:` (ex: `$Script:easeBounceOut`).
Vous pouvez consulter des exemples visuels de ces courbes sur [easings.net](https://easings.net/).

Principaux types :
- `Linear`
- `Expo`
- `Bounce`
- `Elastic`
- `Back`

## Performances

Le moteur est optimisé pour tourner à **60 FPS** (`$Script:refreshRate = 60`). 

### Recommandations :
- **Nettoyage** : Les animations terminées sont automatiquement retirées de la liste par le moteur pour économiser les ressources.
- **Gestion du Timer** : Il est impératif d'arrêter et de supprimer le Timer WinForms lors de la fermeture du formulaire pour éviter les fuites de mémoire.

```powershell
$mainForm.Add_Closing({ 
    $timer.Stop()
    $timer.Dispose() 
})
```

---
*Documentation générée pour le projet Tweens PowerShell.*