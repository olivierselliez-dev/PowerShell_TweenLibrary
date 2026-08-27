# 🎬 Bibliothèque PowerShell Tween

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue.svg)](https://microsoft.com/PowerShell)
[![Plateforme](https://img.shields.io/badge/Plateforme-Windows%20(WinForms)-0078D6.svg)](#pr%C3%A9requis)
[![Algorithmes d'Easing](https://img.shields.io/badge/Algorithmes%20d'Easing-41%20Courbes-orange.svg)](#5-r%C3%A9f%C3%A9rence-des-algorithmes-deasing)
[![Licence](https://img.shields.io/badge/Licence-MIT-green.svg)](#9-licence--cr%C3%A9dits)

*Créé par **Olivier Selliez** | [olivier.selliez.dev@gmail.com](mailto:olivier.selliez.dev@gmail.com)*

Un moteur d'animation et de tweening léger, orienté objet (classes), conçu pour **Windows Forms** en PowerShell. Cette bibliothèque implémente l'ensemble des équations d'atténuation (easing) de Robert Penner pour offrir des transitions fluides, non linéaires et dynamiques aux applications de bureau en PowerShell.

**And yes, it's quite useless but it's funny :)**

---

## 📑 Table des Matières

1. [Fonctionnalités](#1-fonctionnalit%C3%A9s)
2. [Architecture du Projet](#2-architecture-du-projet)
3. [Guide de Démarrage](#3-guide-de-d%C3%A9marrage)
   - [Prérequis](#pr%C3%A9requis)
   - [Importation des Modules (Dot-Sourcing)](#importation-des-modules-dot-sourcing)
   - [Configuration et Cycle de Vie du Moteur](#configuration-et-cycle-de-vie-du-moteur)
   - [Exemple Minimal Exécutable](#exemple-minimal-ex%C3%A9cutable)
4. [Référence des Classes de Tween](#4-r%C3%A9f%C3%A9rence-des-classes-de-tween)
   - [Classe de Base : `Tween`](#classe-de-base--tween)
   - [1. `TweenMoveTo` (Position / Coordonnées)](#1-tweenmoveto)
   - [2. `TweenColorARGB` (Couleurs et Canal Alpha)](#2-tweencolorargb)
   - [3. `TweenNumericString` (Valeurs Numériques Textuelles / Compteurs)](#3-tweennumericstring)
   - [4. `TweenProgressBar` (Barres de Progression)](#4-tweenprogressbar)
   - [5. `TweenOpacity` (Transparence de Formulaire)](#5-tweenopacity)
   - [6. `TweenWaiter` (Délais et Minuteurs)](#6-tweenwaiter)
5. [Référence des Algorithmes d'Easing](#5-r%C3%A9f%C3%A9rence-des-algorithmes-deasing)
   - [Variations d'Atténuation (In, Out, InOut, OutIn)](#variations-datt%C3%A9nuation)
   - [Tableau Exhaustif des Constantes d'Easing (41 Courbes)](#tableau-exhaustif-des-constantes-deasing)
6. [Patterns et Recettes Avancées](#6-patterns-et-recettes-avanc%C3%A9es)
   - [Enchaînement d'Animations et Callbacks](#encha%C3%AEnement-danimations-et-callbacks)
   - [Passage d'Arguments Personnalisés aux Callbacks](#passage-darguments-personnalis%C3%A9s-aux-callbacks)
   - [Animations Échelonnées (Staggering)](#animations-%C3%A9chelonn%C3%A9es-staggering)
   - [Mise en Pause, Reprise et Annulation](#mise-en-pause-reprise-et-annulation)
   - [Création de Classes de Tween Personnalisées](#cr%C3%A9ation-de-classes-de-tween-personnalis%C3%A9es)
7. [Exécution de la Démo Interactive](#7-ex%C3%A9cution-de-la-d%C3%A9mo-interactive)
8. [Notes Techniques et Bonnes Pratiques](#8-notes-techniques-et-bonnes-pratiques)
9. [Licence et Crédits](#9-licence-et-cr%C3%A9dits)

---

## 1. ✨ Fonctionnalités

- **41 Courbes d'Atténuation de Robert Penner** : Intègre toutes les familles classiques (Linear, Quad, Cubic, Quart, Quint, Sine, Expo, Circ, Elastic, Bounce, Back) déclinées selon les modes `In`, `Out`, `InOut` et `OutIn`.
- **Pur PowerShell 5.1+ Orienté Objet** : Implémenté nativement avec les classes PowerShell pour des performances optimales et un code structuré.
- **Zéro Dépendance Externe** : Fonctionne uniquement avec les composants standards .NET `System.Windows.Forms` et `System.Drawing`.
- **Couverture Complète des Propriétés UI** : Anime positions (`Point`), couleurs (`ForeColor` / `BackColor` avec interpolation des canaux ARGB), texte numérique, barres de progression et opacité globale de fenêtres.
- **Architecture Événementielle & Séquençable** : Support natif des délais de départ, mise en pause/reprise, arrêt immédiat, finalisation forcée et callbacks d'achèvement avec transmission d'arguments.
- **Gestion Automatisée du Cycle de Vie** : Chaque instance de tween s'enregistre automatiquement dans la boucle moteur active et se retire d'elle-même dès achèvement.

---

## 2. 🏛 Architecture du Projet

Le projet est structuré de manière modulaire au sein du répertoire `Tweens/` :

```
PowerShell_TweenLibrary/
├── Demo.ps1                     # Application de démonstration WinForms complète et interactive
├── run.bat                      # Lanceur batch rapide pour Demo.ps1
├── Tweens/
│   ├── TweensVariables.ps1      # Constantes textuelles d'easing ($Script:ease*)
│   ├── Tweens.ps1               # Modèles de données OOP (Tween, TweenMoveTo, etc.)
│   ├── TweensUpdater.ps1        # Boucle de rafraîchissement globale et Timer WinForms
│   └── TweensMovement.ps1       # Fonctions mathématiques d'easing et mutations de propriétés
├── Documentations/
│   ├── Documentation_Full_EN.md # Documentation complète en anglais
│   ├── Documentation_Full_FR.md # Documentation complète en français
│   ├── Documentation_Full_EN.html # Version web interactive en anglais
│   └── Documentation_Full_FR.html # Version web interactive en français
└── README.md                    # Documentation principale du dépôt
```

| Fichier | Rôle | Responsabilités Principales |
| :--- | :--- | :--- |
| `TweensVariables.ps1` | **Constantes** | Déclare les 41 identifiants d'easing dans le scope `$Script` (ex: `$Script:easeBounceOut`). |
| `Tweens.ps1` | **Modèles de Données** | Définit la classe de base `Tween` et ses classes dérivées spécialisées (`TweenMoveTo`, `TweenColorARGB`, etc.). |
| `TweensUpdater.ps1` | **Moteur & Timer** | Gère le `$Script:tweensTimer`, la liste active `$Script:tweensList`, la cadence et le dispatch par frame. |
| `TweensMovement.ps1` | **Mathématiques & Logique** | Implémente la fonction centrale `Ease` ainsi que les mutateurs par type (`MoveTo`, `ColorARGB`, etc.). |

---

## 3. 🚀 Guide de Démarrage

### Prérequis

- **Windows PowerShell 5.1** ou **PowerShell 7+ (pwsh)** sous Windows.
- Les bibliothèques WinForms .NET standards (`System.Windows.Forms` et `System.Drawing`).

### Importation des Modules (Dot-Sourcing)

Importez les fichiers de la bibliothèque au début de votre script dans l'ordre suivant :

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "$PSScriptRoot\Tweens\TweensVariables.ps1"
. "$PSScriptRoot\Tweens\Tweens.ps1"
. "$PSScriptRoot\Tweens\TweensUpdater.ps1"
. "$PSScriptRoot\Tweens\TweensMovement.ps1"
```

### Configuration et Cycle de Vie du Moteur

La boucle d'animation s'appuie sur un `System.Windows.Forms.Timer` (`$Script:tweensTimer`). Pour garantir une exécution fluide et éviter les fuites de mémoire dans la session PowerShell, associez le minuteur aux événements du formulaire :

```powershell
# 1. Démarrer le moteur d'animation lors de l'affichage du formulaire
$mainForm.Add_Shown({
    $Script:tweensTimer.Start()
})

# 2. CRITIQUE : Arrêter et libérer (Dispose) le Timer lors de la fermeture
$mainForm.Add_Closing({
    $Script:tweensTimer.Stop()
    $Script:tweensTimer.Dispose()
})
```

> [!TIP]
> **Personnalisation de la fréquence d'images (FPS)** : La cadence par défaut est fixée à **60 FPS** (`$Script:refreshRate = 60` dans `TweensUpdater.ps1`). Vous pouvez ajuster cette variable selon vos besoins avant de démarrer le minuteur.

### Exemple Minimal Exécutable

Copiez et exécutez ce script autonome pour observer un bouton rebondir vers sa nouvelle position :

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Importation de la bibliothèque
. "$PSScriptRoot\Tweens\TweensVariables.ps1"
. "$PSScriptRoot\Tweens\Tweens.ps1"
. "$PSScriptRoot\Tweens\TweensUpdater.ps1"
. "$PSScriptRoot\Tweens\TweensMovement.ps1"

# Création du Formulaire
$form = [System.Windows.Forms.Form]::new()
$form.Text = "Exemple Minimal Tween"
$form.Size = [System.Drawing.Size]::new(400, 300)
$form.StartPosition = "CenterScreen"

# Création d'un Bouton
$btn = [System.Windows.Forms.Button]::new()
$btn.Text = "Cliquez-moi !"
$btn.Size = [System.Drawing.Size]::new(130, 40)
$btn.Location = [System.Drawing.Point]::new(20, 20)
$form.Controls.Add($btn)

# Déclenchement de l'animation lors du clic
$btn.Add_Click({
    $destination = [System.Drawing.Point]::new(220, 180)
    $tween = [TweenMoveTo]::new($btn, $destination, 1.5, $Script:easeBounceOut)
    $tween.setOnComplete({
        $btn.Text = "Arrivé !"
    })
})

# Gestion du cycle de vie du Timer
$form.Add_Shown({ $Script:tweensTimer.Start() })
$form.Add_Closing({
    $Script:tweensTimer.Stop()
    $Script:tweensTimer.Dispose()
})

# Lancement de l'interface graphique
[System.Windows.Forms.Application]::Run($form)
```

---

## 4. 📚 Référence des Classes de Tween

Toutes les classes d'animation héritent de la classe abstraite `Tween`. Chaque fois qu'une instance de tween est créée via son constructeur `::new(...)`, elle est **automatiquement enregistrée** dans `$Script:tweensList` et sera mise à jour dès le tick suivant.

```
                  ┌──────────────┐
                  │    Tween     │ (Classe de Base)
                  └──────┬───────┘
     ┌──────────────┬────┴─────────┬────────────────┬────────────────┬──────────────┐
     │              │              │                │                │              │
┌────┴────────┐┌────┴─────────┐┌───┴──────────┐┌────┴───────────┐┌───┴──────────┐┌───┴─────────┐
│ TweenMoveTo ││TweenColorARGB││TweenNumeric- ││TweenProgressBar││ TweenOpacity ││ TweenWaiter │
│             ││              ││   String     ││                ││              ││             │
└─────────────┘└──────────────┘└──────────────┘└────────────────┘└──────────────┘└─────────────┘
```

---

### Classe de Base : `Tween`

Fondation de toutes les animations. Gère le minutage, les délais, les états de pause et l'exécution des callbacks.

#### Propriétés
| Propriété | Type | Description |
| :--- | :--- | :--- |
| `control` | `[System.Object]` | Contrôle WinForms ou Formulaire cible de l'animation. |
| `easing` | `[string]` | Identifiant textuel de la courbe d'easing de Robert Penner. |
| `duration` | `[double]` | Durée totale convertie en ticks internes (`secondes * $refreshRate`). |
| `delay` | `[double]` | Délai restant en ticks avant le démarrage effectif de l'animation. |
| `nbTicks` | `[int]` | Compteur de ticks écoulés depuis le début de la phase courante. |
| `isPaused` | `[bool]` | Indique si l'animation est actuellement en pause. |
| `startTime` | `[DateTime]` | Date et heure de création du tween. |
| `onComplete` | `[ScriptBlock]` | ScriptBlock exécuté dès l'achèvement de l'animation. |
| `onCompleteArgs`| `[System.Object[]]` | Arguments optionnels transmis au callback `onComplete`. |

#### Méthodes
| Méthode | Signature | Description | Exemple |
| :--- | :--- | :--- | :--- |
| **`setDelay`** | `[void] setDelay([double]$secondes)` | Définit un délai en secondes avant le début de l'animation. | `$t.setDelay(0.5)` |
| **`setOnComplete`** | `[void] setOnComplete([scriptblock]$cb)` | Enregistre un callback exécuté à la fin du tween. | `$t.setOnComplete({ Write-Host "Terminé !" })` |
| **`setOnComplete`** | `[void] setOnComplete([scriptblock]$cb, [object[]]$args)` | Enregistre un callback avec arguments personnalisés. | `$t.setOnComplete({ param($t, $msg) Write-Host $msg }, @("Terminé !"))` |
| **`pause`** | `[void] pause([bool]$estEnPause)` | Met en pause (`$true`) ou reprend (`$false`) l'animation. | `$t.pause($true)` |
| **`stop`** | `[void] stop()` | Interrompt immédiatement le tween et le retire de la boucle d'animation. | `$t.stop()` |
| **`forceEnd`** | `[void] forceEnd()` | Annule le délai restant et avance au tick final pour conclure l'animation au prochain tick. | `$t.forceEnd()` |

---

### 1. `TweenMoveTo`

Anime le déplacement 2D (`Location`) d'un contrôle Windows Forms vers des coordonnées cibles (`Point(X, Y)`).

```powershell
[TweenMoveTo]::new([Control]$pControl, [System.Drawing.Point]$pDestPos, [double]$pDuration, [string]$pEasing)
```

- **Paramètres** :
  - `$pControl` : Le contrôle WinForms à déplacer.
  - `$pDestPos` : Les coordonnées de destination `[System.Drawing.Point]`.
  - `$pDuration` : Durée du déplacement en secondes.
  - `$pEasing` : Identifiant de la courbe d'easing (ex: `$Script:easeCubicOut`).
- **Exemple** :
  ```powershell
  $cible = [System.Drawing.Point]::new(350, 120)
  $moveTween = [TweenMoveTo]::new($monBouton, $cible, 1.2, $Script:easeElasticOut)
  $moveTween.setDelay(0.2)
  ```

---

### 2. `TweenColorARGB`

Anime en fondu les propriétés de couleur (`ForeColor` ou `BackColor`) d'un contrôle en interpolant indépendamment les canaux Alpha, Rouge, Vert et Bleu.

```powershell
[TweenColorARGB]::new([Control]$pControl, [string]$pType, [System.Drawing.Color]$pStartColor, [System.Drawing.Color]$pEndColor, [double]$pDuration, [string]$pEasing)
```

- **Paramètres** :
  - `$pControl` : Le contrôle cible.
  - `$pType` : Propriété à modifier : `"ForeColor"` ou `"BackColor"`.
  - `$pStartColor` : Couleur initiale `[System.Drawing.Color]`.
  - `$pEndColor` : Couleur finale `[System.Drawing.Color]`.
  - `$pDuration` : Durée de transition en secondes.
  - `$pEasing` : Identifiant de la courbe d'easing.
- **Exemple** :
  ```powershell
  $colDepart = [System.Drawing.Color]::FromArgb(255, 30, 30, 30)
  $colFin    = [System.Drawing.Color]::FromArgb(255, 0, 122, 255)
  $colorTween = [TweenColorARGB]::new($monLabel, "BackColor", $colDepart, $colFin, 0.8, $Script:easeQuadInOut)
  ```

---

### 3. `TweenNumericString`

Anime une valeur numérique affichée dans la propriété `Text` d'un contrôle (idéal pour compteurs, jauges et statistiques).

```powershell
[TweenNumericString]::new([Control]$pControl, [string]$pType, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing)
```

- **Paramètres** :
  - `$pControl` : Le contrôle hôte (`Label`, `Button`, `TextBox`, etc.).
  - `$pType` : Type d'affichage : `"int"` (entier tronqué) ou `"double"` (arrondi à 2 décimales).
  - `$pStartValue` : Nombre de départ.
  - `$pEndValue` : Nombre d'arrivée.
  - `$pDuration` : Durée en secondes.
  - `$pEasing` : Identifiant de la courbe d'easing.
- **Exemple** :
  ```powershell
  # Anime un score de 0 à 1500 sur 2.5 secondes
  $numTween = [TweenNumericString]::new($lblScore, "int", 0, 1500, 2.5, $Script:easeExpoOut)
  ```

---

### 4. `TweenProgressBar`

Anime la propriété `Value` d'un contrôle `System.Windows.Forms.ProgressBar`.

```powershell
[TweenProgressBar]::new([ProgressBar]$pProgressBar, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing)
```

- **Paramètres** :
  - `$pProgressBar` : Instance du contrôle ProgressBar.
  - `$pStartValue` : Valeur initiale (pourcentage / entier).
  - `$pEndValue` : Valeur finale.
  - `$pDuration` : Durée en secondes.
  - `$pEasing` : Identifiant de la courbe d'easing.
- **Exemple** :
  ```powershell
  $barTween = [TweenProgressBar]::new($maProgressBar, 0, 100, 3.0, $Script:easeCubicInOut)
  ```

---

### 5. `TweenOpacity`

Anime en fondu la transparence globale d'une fenêtre Windows Forms via sa propriété `Opacity` (valeur bornée entre `0.0` et `1.0`).

```powershell
[TweenOpacity]::new([Control]$pForm, [double]$pEndValue, [double]$pDuration, [string]$pEasing)
```

- **Paramètres** :
  - `$pForm` : Instance de la fenêtre Form cible.
  - `$pEndValue` : Opacité finale (`0.0` pour transparent, `1.0` pour totalement opaque).
  - `$pDuration` : Durée du fondu en secondes.
  - `$pEasing` : Identifiant de la courbe d'easing.
- **Exemple** :
  ```powershell
  # Fondu d'apparition d'une fenêtre sur 0.75 seconde
  $fadeTween = [TweenOpacity]::new($maFenetre, 1.0, 0.75, $Script:easeSineOut)
  ```

---

### 6. `TweenWaiter`

Minuteur non-bloquant qui exécute un ScriptBlock à la fin d'une durée spécifiée sans modifier aucune propriété graphique. Idéal pour séquencer et espacer les animations.

```powershell
[TweenWaiter]::new([System.Object]$pControl, [double]$pDuration, [scriptblock]$pCallBack)
```

- **Paramètres** :
  - `$pControl` : Objet de contexte (peut être `$null` ou un contrôle particulier).
  - `$pDuration` : Temps d'attente en secondes.
  - `$pCallBack` : ScriptBlock à exécuter à l'échéance.
- **Exemple** :
  ```powershell
  [TweenWaiter]::new($null, 2.0, {
      [System.Windows.Forms.MessageBox]::Show("2 secondes se sont écoulées !")
  })
  ```

---

## 5. 📐 Référence des Algorithmes d'Easing

Les fonctions d'atténuation (easing) modélisent la vitesse d'accélération et de décélération d'une transition dans le temps. Pour visualiser ces courbes mathématiques, consultez [easings.net](https://easings.net/).

### Variations d'Atténuation

Chaque famille d'algorithmes (à l'exception de `Linear`) se décline en quatre modes distincts :

| Variation | Suffixe | Description |
| :--- | :--- | :--- |
| **Ease In** | `*EaseIn` | Démarre lentement puis accélère vers la fin. |
| **Ease Out** | `*EaseOut` | Démarre rapidement puis décélère vers un arrêt doux. |
| **Ease In-Out** | `*EaseInOut` | Accélère durant la première moitié, puis décélère vers la fin. |
| **Ease Out-In** | `*EaseOutIn` | Décélère durant la première moitié, puis réaccélère sur la fin. |

---

### Tableau Exhaustif des Constantes d'Easing

Toutes les constantes sont accessibles via la syntaxe `$Script:ease<Nom>` (ou `$ease<Nom>` dans le scope où `TweensVariables.ps1` est importé) :

| Famille | Nom de la Variable | Valeur Chaîne | Description Mathématique |
| :--- | :--- | :--- | :--- |
| **Linear** | `$Script:easeLinear` | `"Linear"` | Vitesse constante (interpolation linéaire simple). |
| **Quad** | `$Script:easeQuadIn`<br>`$Script:easeQuadOut`<br>`$Script:easeQuadInOut`<br>`$Script:easeQuadOutIn` | `"QuadEaseIn"`<br>`"QuadEaseOut"`<br>`"QuadEaseInOut"`<br>`"QuadEaseOutIn"` | Courbe quadratique ($t^2$). Transition subtile et naturelle. |
| **Cubic** | `$Script:easeCubicIn`<br>`$Script:easeCubicOut`<br>`$Script:easeCubicInOut`<br>`$Script:easeCubicOutIn` | `"CubicEaseIn"`<br>`"CubicEaseOut"`<br>`"CubicEaseInOut"`<br>`"CubicEaseOutIn"` | Courbe cubique ($t^3$). Accélération plus prononcée. |
| **Quart** | `$Script:easeQuartIn`<br>`$Script:easeQuartOut`<br>`$Script:easeQuartInOut`<br>`$Script:easeQuartOutIn` | `"QuartEaseIn"`<br>`"QuartEaseOut"`<br>`"QuartEaseInOut"`<br>`"QuartEaseOutIn"` | Courbe quartique ($t^4$). Dynamique et nerveuse. |
| **Quint** | `$Script:easeQuintIn`<br>`$Script:easeQuintOut`<br>`$Script:easeQuintInOut`<br>`$Script:easeQuintOutIn` | `"QuintEaseIn"`<br>`"QuintEaseOut"`<br>`"QuintEaseInOut"`<br>`"QuintEaseOutIn"` | Courbe quintique ($t^5$). Accélération très abrupte. |
| **Sine** | `$Script:easeSineIn`<br>`$Script:easeSineOut`<br>`$Script:easeSineInOut`<br>`$Script:easeSineOutIn` | `"SineEaseIn"`<br>`"SineEaseOut"`<br>`"SineEaseInOut"`<br>`"SineEaseOutIn"` | Courbe trigonométrique sinusoïdale. Très douce et organique. |
| **Expo** | `$Script:easeExpoIn`<br>`$Script:easeExpoOut`<br>`$Script:easeExpoInOut`<br>`$Script:easeExpoOutIn` | `"ExpoEaseIn"`<br>`"ExpoEaseOut"`<br>`"ExpoEaseInOut"`<br>`"ExpoEaseOutIn"` | Courbe exponentielle ($2^{10(t-1)}$). Effet ultra-réactif et percutant. |
| **Circ** | `$Script:easeCircIn`<br>`$Script:easeCircOut`<br>`$Script:easeCircInOut`<br>`$Script:easeCircOutIn` | `"CircEaseIn"`<br>`"CircEaseOut"`<br>`"CircEaseInOut"`<br>`"CircEaseOutIn"` | Courbe circulaire ($\sqrt{1 - t^2}$). Démarrage vif et arrêt net. |
| **Back** | `$Script:easeBackIn`<br>`$Script:easeBackOut`<br>`$Script:easeBackInOut`<br>`$Script:easeBackOutIn` | `"BackEaseIn"`<br>`"BackEaseOut"`<br>`"BackEaseInOut"`<br>`"BackEaseOutIn"` | Effet de dépassement : recule légèrement au début ou dépasse sa cible avant de s'y stabiliser. |
| **Elastic** | `$Script:easeElasticIn`<br>`$Script:easeElasticOut`<br>`$Script:easeElasticInOut`<br>`$Script:easeElasticOutIn` | `"ElasticEaseIn"`<br>`"ElasticEaseOut"`<br>`"ElasticEaseInOut"`<br>`"ElasticEaseOutIn"` | Effet de ressort / élastique avec oscillations amorties. |
| **Bounce** | `$Script:easeBounceIn`<br>`$Script:easeBounceOut`<br>`$Script:easeBounceInOut`<br>`$Script:easeBounceOutIn` | `"BounceEaseIn"`<br>`"BounceEaseOut"`<br>`"BounceEaseInOut"`<br>`"BounceEaseOutIn"` | Effet de rebond parabolique décroissant. |

---

## 6. 💡 Patterns et Recettes Avancées

### Enchaînement d'Animations et Callbacks

Enchaînez plusieurs animations à la suite grâce à la méthode `setOnComplete` :

```powershell
# Déplacement à droite, puis changement de couleur, puis descente
$p1 = [System.Drawing.Point]::new(200, 50)
$p2 = [System.Drawing.Point]::new(200, 200)

$t1 = [TweenMoveTo]::new($monBouton, $p1, 0.8, $Script:easeCubicOut)
$t1.setOnComplete({
    $c = [TweenColorARGB]::new($monBouton, "BackColor", [System.Drawing.Color]::Gray, [System.Drawing.Color]::ForestGreen, 0.5, $Script:easeLinear)
    $c.setOnComplete({
        [TweenMoveTo]::new($monBouton, $p2, 0.8, $Script:easeBounceOut)
    })
})
```

---

### Passage d'Arguments Personnalisés aux Callbacks

Le callback reçoit automatiquement **`$tweenObj`** en premier paramètre, suivi des arguments personnalisés spécifiés dans `setOnComplete($callback, $arguments)` :

```powershell
$myTween = [TweenMoveTo]::new($panel, [System.Drawing.Point]::new(0, 0), 1.0, $Script:easeExpoOut)

$callback = {
    param($instanceTween, $messagePerso, $nouvelEtat)
    Write-Host "Animation terminée sur le contrôle : $($instanceTween.control.Name)"
    Write-Host "Message : $messagePerso | État : $nouvelEtat"
}

$myTween.setOnComplete($callback, @("Volet ouvert avec succès", 1))
```

---

### Animations Échelonnées (Staggering)

Animez une série d'éléments avec un décalage progressif via `.setDelay()` :

```powershell
$elements = @($carte1, $carte2, $carte3, $carte4)
$delaiBase = 0.1

for ($i = 0; $i -lt $elements.Count; $i++) {
    $cible = [System.Drawing.Point]::new(50, 50 + ($i * 60))
    $tw = [TweenMoveTo]::new($elements[$i], $cible, 0.6, $Script:easeBackOut)
    $tw.setDelay($i * $delaiBase)
}
```

---

### Mise en Pause, Reprise et Annulation

Contrôlez l'état des animations en direct :

```powershell
# Mettre en pause une animation
$monTween.pause($true)

# Reprendre l'animation
$monTween.pause($false)

# Stopper et retirer immédiatement de la boucle
$monTween.stop()

# Forcer l'animation à atteindre son état final immédiatement
$monTween.forceEnd()
```

---

### Création de Classes de Tween Personnalisées

Il est très facile d'étendre la bibliothèque pour créer vos propres animations :

1. **Hériter de `Tween` dans `Tweens.ps1`** :
   ```powershell
   class TweenSize : Tween {
       [System.Drawing.Size]$startSize
       [System.Drawing.Size]$destSize
       [System.Drawing.Size]$delta

       TweenSize([Control]$pControl, [System.Drawing.Size]$pDestSize, [double]$pDuration, [string]$pEasing) {
           $this.control = $pControl
           $this.easing = $pEasing
           $this.destSize = $pDestSize
           $this.duration = $pDuration * $Script:refreshRate
           $this.startSize = $pControl.Size
           $this.delta = [System.Drawing.Size]::new($pDestSize.Width - $pControl.Width, $pDestSize.Height - $pControl.Height)
       }
   }
   ```

2. **Ajouter la fonction de mise à jour dans `TweensMovement.ps1`** :
   ```powershell
   function SizeControl([TweenSize]$tweenObj) {
       $tweenObj.nbTicks++
       if ($tweenObj.nbTicks -gt $tweenObj.duration) {
           $tweenObj.control.Size = $tweenObj.destSize
           $Script:tweensList.Remove($tweenObj)
           Invoke-TweenCallback $tweenObj
       }
       else {
           $w = Ease $tweenObj.easing $tweenObj.startSize.Width $tweenObj.delta.Width $tweenObj.nbTicks $tweenObj.duration
           $h = Ease $tweenObj.easing $tweenObj.startSize.Height $tweenObj.delta.Height $tweenObj.nbTicks $tweenObj.duration
           $tweenObj.control.Size = [System.Drawing.Size]::new($w, $h)
       }
   }
   ```

3. **Enregistrer le gestionnaire dans `TweensUpdater.ps1`** :
   ```powershell
   "TweenSize" { SizeControl $tween }
   ```

---

## 7. 🎮 Exécution de la Démo Interactive

Le dépôt contient une application de démonstration graphique complète (`Demo.ps1`) permettant d'expérimenter en temps réel chaque courbe d'easing, durée, délai et type d'animation.

Pour lancer la démo :

### Via le fichier Batch :
Double-cliquez sur `run.bat` ou lancez dans le terminal :
```cmd
run.bat
```

### Via PowerShell :
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\Demo.ps1
```

---

## 8. ⚙️ Notes Techniques et Bonnes Pratiques

1. **Modèle de Threading WinForms (STA)** : Les applications Windows Forms s'exécutent en mode Single-Threaded Apartment. Toutes les mises à jour visuelles s'effectuent sur le thread principal de l'UI. Évitez les opérations synchrones bloquantes (ex: `Start-Sleep` ou appels réseau synchrones) pendant qu'une animation est active pour prévenir les saccades.
2. **Calcul par Ticks vs Temps Réel** : La durée interne est calculée selon `ticks = dureeEnSecondes * refreshRate`. Même si le thread UI subit un léger ralentissement passager, les ticks sont comptabilisés séquentiellement, garantissant que chaque contrôle atteint exactement ses coordonnées ou valeurs cibles sans dépassement.
3. **Nettoyage du Timer** : Appelez impérativement `$Script:tweensTimer.Stop()` et `$Script:tweensTimer.Dispose()` dans l'événement `Closing` ou `FormClosed` de votre formulaire. Dans le cas contraire, le timer continuera de tourner en tâche de fond dans votre session hôte PowerShell (ISE, VS Code, etc.).

---

## 9. 📄 Licence et Crédits

- **Auteur** : Olivier Selliez ([olivier.selliez.dev@gmail.com](mailto:olivier.selliez.dev@gmail.com))
- **Équations d'Easing** : Basé sur les travaux de Robert Penner ([robertpenner.com/easing](http://robertpenner.com/easing/)).
- **Licence** : Licence MIT. Libre d'utilisation, de modification et de distribution pour projets personnels et commerciaux.
