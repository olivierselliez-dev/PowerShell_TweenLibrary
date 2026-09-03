# 🎬 PowerShell Tween Library

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue.svg)](https://microsoft.com/PowerShell)
[![Platform](https://img.shields.io/badge/Platform-Windows%20(WinForms)-0078D6.svg)](#prerequisites)
[![Easing Algorithms](https://img.shields.io/badge/Easing%20Algorithms-41%20Curves-orange.svg)](#4-easing-algorithms-reference)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#license--credits)

*Created by **Olivier Selliez** | [olivier.selliez.dev@gmail.com](mailto:olivier.selliez.dev@gmail.com)*

A lightweight, class-based animation and tweening engine for **Windows Forms** in PowerShell. This library implements Robert Penner's easing equations to deliver silky-smooth, non-linear transitions and dynamic UI animations for desktop PowerShell applications.

**And yes, it's quite useless but it's funny :)**

---

## 📑 Table of Contents

1. [Features](#-features)
2. [Project Architecture](#-project-architecture)
3. [Getting Started](#-getting-started)
   - [Prerequisites](#prerequisites)
   - [Dot-Sourcing the Modules](#dot-sourcing-the-modules)
   - [Engine Lifecycle & Configuration](#engine-lifecycle--configuration)
   - [Minimal Working Example](#minimal-working-example)
4. [Tween Class Reference](#-tween-class-reference)
   - [Base Class: `Tween`](#base-class-tween)
   - [1. `TweenMoveTo` (Position / Location)](#1-tweenmoveto)
   - [2. `TweenColorARGB` (Colors & Alpha)](#2-tweencolorargb)
   - [3. `TweenNumericString` (Numeric Text / Counters)](#3-tweennumericstring)
   - [4. `TweenProgressBar` (Progress Values)](#4-tweenprogressbar)
   - [5. `TweenOpacity` (Form Transparency)](#5-tweenopacity)
   - [6. `TweenWaiter` (Delays & Timers)](#6-tweenwaiter)
5. [Easing Algorithms Reference](#-easing-algorithms-reference)
   - [Easing Variations (In, Out, InOut, OutIn)](#easing-variations)
   - [Full Easing Constants Table (41 Curves)](#full-easing-constants-table)
6. [Advanced Patterns & Recipes](#-advanced-patterns--recipes)
   - [Animation Chaining & Callbacks](#animation-chaining--callbacks)
   - [Passing Custom Arguments to Callbacks](#passing-custom-arguments-to-callbacks)
   - [Staggered Animations](#staggered-animations)
   - [Pausing, Resuming, and Cancelling](#pausing-resuming-and-cancelling)
   - [Creating Custom Tween Classes](#creating-custom-tween-classes)
7. [Running the Interactive Demo](#-running-the-interactive-demo)
8. [Technical Notes & Best Practices](#-technical-notes--best-practices)
9. [License & Credits](#-license--credits)

---

## ✨ Features

- **41 Robert Penner Easing Curves**: Includes all standard easing curves (Linear, Quad, Cubic, Quart, Quint, Sine, Expo, Circ, Elastic, Bounce, Back) across `In`, `Out`, `InOut`, and `OutIn` modes.
- **Pure PowerShell 5.1+ OOP**: Implemented natively using PowerShell classes for high performance and clean structure.
- **Zero Binary Dependencies**: Relies exclusively on built-in .NET `System.Windows.Forms` and `System.Drawing` assemblies.
- **Comprehensive Control Coverage**: Animate positions (`Point`), colors (`ForeColor` / `BackColor` with ARGB channel blending), numeric text strings, progress bars, and form opacity.
- **Event-Driven & Sequence-Ready**: Native support for start delays, pause/resume, force-finish, and completion callbacks with arbitrary argument injection.
- **Auto-Managed Lifecycle**: Instantiated tweens automatically register to the active engine list and deregister themselves upon completion.

---

## 🏛 Project Architecture

The library is organized into modular scripts under the `Tweens/` directory:

```
PowerShell_TweenLibrary/
├── Demo.ps1                     # Full interactive WinForms showcase application
├── run.bat                      # One-click batch launcher for Demo.ps1
├── Tweens/
│   ├── TweensVariables.ps1      # Easing curve string constants ($Script:ease*)
│   ├── Tweens.ps1               # OOP class definitions (Tween, TweenMoveTo, etc.)
│   ├── TweensUpdater.ps1        # Global update loop and WinForms Timer manager
│   └── TweensMovement.ps1       # Easing math calculations and property modifiers
└── README.md                    # Project documentation
```

| File | Purpose | Key Responsibilities |
| :--- | :--- | :--- |
| `TweensVariables.ps1` | **Constants** | Defines the 41 script-scoped easing identifier variables (e.g., `$Script:easeBounceOut`). |
| `Tweens.ps1` | **Data Models** | Defines the `Tween` base class and specialized derived classes (`TweenMoveTo`, `TweenColorARGB`, etc.). |
| `TweensUpdater.ps1` | **Engine & Timer** | Manages `$Script:tweensTimer`, `$Script:tweensList`, refresh rate, and frame-by-frame dispatching. |
| `TweensMovement.ps1` | **Math & Logic** | Implements the core `Ease` math function and per-type mutation functions (`MoveTo`, `ColorARGB`, etc.). |

---

## 🚀 Getting Started

### Prerequisites

- **PowerShell 5.1** (Windows PowerShell) or **PowerShell 7+ (pwsh)** on Windows.
- Standard .NET WinForms assemblies (`System.Windows.Forms` and `System.Drawing`).

### Dot-Sourcing the Modules

Import the library files into your script in the following order:

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "$PSScriptRoot\Tweens\TweensVariables.ps1"
. "$PSScriptRoot\Tweens\Tweens.ps1"
. "$PSScriptRoot\Tweens\TweensUpdater.ps1"
. "$PSScriptRoot\Tweens\TweensMovement.ps1"
```

### Engine Lifecycle & Configuration

The animation loop is driven by a `System.Windows.Forms.Timer` (`$Script:tweensTimer`). To ensure proper execution and prevent memory leaks, bind the timer to your Form's lifecycle events:

```powershell
# 1. Start the animation loop when the window is displayed
$mainForm.Add_Shown({
    $Script:tweensTimer.Start()
})

# 2. CRITICAL: Stop and dispose the timer when closing to release the UI thread
$mainForm.Add_Closing({
    $Script:tweensTimer.Stop()
    $Script:tweensTimer.Dispose()
})
```

> [!TIP]
> **Customizing Frame Rate**: The default refresh rate is **60 FPS** (`$Script:refreshRate = 60` in `TweensUpdater.ps1`). You can adjust this before starting the timer if needed.

### Minimal Working Example

Save and run the following self-contained script to see a button smoothly bounce into position:

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Dot-source the library
. "$PSScriptRoot\Tweens\TweensVariables.ps1"
. "$PSScriptRoot\Tweens\Tweens.ps1"
. "$PSScriptRoot\Tweens\TweensUpdater.ps1"
. "$PSScriptRoot\Tweens\TweensMovement.ps1"

# Create a Form
$form = [System.Windows.Forms.Form]::new()
$form.Text = "Tween Minimal Example"
$form.Size = [System.Drawing.Size]::new(400, 300)
$form.StartPosition = "CenterScreen"

# Create a Button
$btn = [System.Windows.Forms.Button]::new()
$btn.Text = "Click Me!"
$btn.Size = [System.Drawing.Size]::new(120, 40)
$btn.Location = [System.Drawing.Point]::new(20, 20)
$form.Controls.Add($btn)

# Trigger an animation on click
$btn.Add_Click({
    $targetPos = [System.Drawing.Point]::new(220, 180)
    $tween = [TweenMoveTo]::new($btn, $targetPos, 1.5, $Script:easeBounceOut)
    $tween.setOnComplete({
        $btn.Text = "Arrived!"
    })
})

# Attach timer to form lifecycle
$form.Add_Shown({ $Script:tweensTimer.Start() })
$form.Add_Closing({
    $Script:tweensTimer.Stop()
    $Script:tweensTimer.Dispose()
})

# Show the GUI
[System.Windows.Forms.Application]::Run($form)
```

---

## 📚 Tween Class Reference

All animation classes derive from the base `Tween` class. Whenever an instance of any `Tween` class is constructed, it is **automatically registered** to `$Script:tweensList` and will be updated on the next tick.

```
                  ┌──────────────┐
                  │    Tween     │ (Base Class)
                  └──────┬───────┘
     ┌──────────────┬────┴─────────┬────────────────┬────────────────┬──────────────┐
     │              │              │                │                │              │
┌────┴────────┐┌────┴─────────┐┌───┴──────────┐┌────┴───────────┐┌───┴──────────┐┌───┴─────────┐
│ TweenMoveTo ││TweenColorARGB││TweenNumeric- ││TweenProgressBar││ TweenOpacity ││ TweenWaiter │
│             ││              ││   String     ││                ││              ││             │
└─────────────┘└──────────────┘└──────────────┘└────────────────┘└──────────────┘└─────────────┘
```

---

### Base Class: `Tween`

The foundation of all animations. Provides timing, delay, pausing, and callback management.

#### Properties
| Property | Type | Description |
| :--- | :--- | :--- |
| `control` | `[System.Object]` | The target UI control or Form being animated. |
| `easing` | `[string]` | Identifier of the Robert Penner easing curve. |
| `duration` | `[double]` | Total duration in internal ticks (`seconds * $refreshRate`). |
| `delay` | `[double]` | Remaining delay in internal ticks before animation starts. |
| `nbTicks` | `[int]` | Number of elapsed ticks for the current phase. |
| `isPaused` | `[bool]` | Whether the animation is currently paused. |
| `startTime` | `[DateTime]` | Timestamp when the tween was instantiated. |
| `onComplete` | `[ScriptBlock]` | Callback executed when the animation finishes. |
| `onCompleteArgs`| `[System.Object[]]` | Optional arguments passed to the `onComplete` callback. |

#### Methods
| Method | Signature | Description | Example |
| :--- | :--- | :--- | :--- |
| **`setDelay`** | `[void] setDelay([double]$seconds)` | Sets a delay in seconds before the animation begins. | `$t.setDelay(0.5)` |
| **`setOnComplete`** | `[void] setOnComplete([scriptblock]$cb)` | Registers a scriptblock callback triggered upon completion. | `$t.setOnComplete({ Write-Host "Done!" })` |
| **`setOnComplete`** | `[void] setOnComplete([scriptblock]$cb, [object[]]$args)` | Registers a callback with custom arguments. | `$t.setOnComplete({ param($t, $msg) Write-Host $msg }, @("Finished!"))` |
| **`pause`** | `[void] pause([bool]$isPaused)` | Pauses (`$true`) or resumes (`$false`) the animation. | `$t.pause($true)` |
| **`stop`** | `[void] stop()` | Immediately cancels the tween and removes it from the update loop. | `$t.stop()` |
| **`forceEnd`** | `[void] forceEnd()` | Clears delay and advances ticks to duration, finalizing the tween on the next tick. | `$t.forceEnd()` |

---

### 1. `TweenMoveTo`

Animates the 2D `Location` (`Point(X, Y)`) of any Windows Forms control.

```powershell
[TweenMoveTo]::new([Control]$pControl, [System.Drawing.Point]$pDestPos, [double]$pDuration, [string]$pEasing)
```

- **Parameters**:
  - `$pControl`: The WinForms control to move.
  - `$pDestPos`: `[System.Drawing.Point]` destination coordinates.
  - `$pDuration`: Movement duration in seconds.
  - `$pEasing`: Easing curve identifier (e.g., `$Script:easeCubicOut`).
- **Example**:
  ```powershell
  $dest = [System.Drawing.Point]::new(350, 120)
  $moveTween = [TweenMoveTo]::new($myButton, $dest, 1.2, $Script:easeElasticOut)
  $moveTween.setDelay(0.2)
  ```

---

### 2. `TweenColorARGB`

Smoothly transitions any color property (`ForeColor` or `BackColor`) across individual Alpha, Red, Green, and Blue channels.

```powershell
[TweenColorARGB]::new([Control]$pControl, [string]$pType, [System.Drawing.Color]$pStartColor, [System.Drawing.Color]$pEndColor, [double]$pDuration, [string]$pEasing)
```

- **Parameters**:
  - `$pControl`: The target control.
  - `$pType`: Color property to animate: `"ForeColor"` or `"BackColor"`.
  - `$pStartColor`: Initial `[System.Drawing.Color]`.
  - `$pEndColor`: Target `[System.Drawing.Color]`.
  - `$pDuration`: Transition duration in seconds.
  - `$pEasing`: Easing curve identifier.
- **Example**:
  ```powershell
  $startCol = [System.Drawing.Color]::FromArgb(255, 30, 30, 30)
  $endCol   = [System.Drawing.Color]::FromArgb(255, 0, 122, 255)
  $colorTween = [TweenColorARGB]::new($myLabel, "BackColor", $startCol, $endCol, 0.8, $Script:easeQuadInOut)
  ```

---

### 3. `TweenNumericString`

Animates a numeric count inside a control's `Text` property (ideal for score counters, statistics, and dashboards).

```powershell
[TweenNumericString]::new([Control]$pControl, [string]$pType, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing)
```

- **Parameters**:
  - `$pControl`: The target control (e.g., `Label`, `Button`, `TextBox`).
  - `$pType`: `"int"` (floored whole numbers) or `"double"` (rounded to 2 decimal places).
  - `$pStartValue`: Initial number.
  - `$pEndValue`: Final number.
  - `$pDuration`: Animation duration in seconds.
  - `$pEasing`: Easing curve identifier.
- **Example**:
  ```powershell
  # Animate score counter from 0 to 1500 over 2.5 seconds
  $numTween = [TweenNumericString]::new($lblScore, "int", 0, 1500, 2.5, $Script:easeExpoOut)
  ```

---

### 4. `TweenProgressBar`

Animates the `Value` property of a `System.Windows.Forms.ProgressBar`.

```powershell
[TweenProgressBar]::new([ProgressBar]$pProgressBar, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing)
```

- **Parameters**:
  - `$pProgressBar`: Target `ProgressBar` instance.
  - `$pStartValue`: Starting percentage / integer value.
  - `$pEndValue`: Target percentage / integer value.
  - `$pDuration`: Duration in seconds.
  - `$pEasing`: Easing curve identifier.
- **Example**:
  ```powershell
  $barTween = [TweenProgressBar]::new($progressBar1, 0, 100, 3.0, $Script:easeCubicInOut)
  ```

---

### 5. `TweenOpacity`

Smoothly fades a Form's transparency by modifying its `Opacity` property (clamped between `0.0` and `1.0`).

```powershell
[TweenOpacity]::new([Control]$pForm, [double]$pEndValue, [double]$pDuration, [string]$pEasing)
```

- **Parameters**:
  - `$pForm`: Target `Form` instance.
  - `$pEndValue`: Target opacity (`0.0` for fully transparent, `1.0` for fully opaque).
  - `$pDuration`: Fade duration in seconds.
  - `$pEasing`: Easing curve identifier.
- **Example**:
  ```powershell
  # Fade in a Form over 0.75 seconds
  $fadeTween = [TweenOpacity]::new($myWindow, 1.0, 0.75, $Script:easeSineOut)
  ```

---

### 6. `TweenWaiter`

A non-blocking timer tween that executes a callback after a given delay without altering any control properties. Perfect for pacing sequences or scheduling delayed events.

```powershell
[TweenWaiter]::new([System.Object]$pControl, [double]$pDuration, [scriptblock]$pCallBack)
```

- **Parameters**:
  - `$pControl`: Context object (can be `$null` or a specific control).
  - `$pDuration`: Wait duration in seconds.
  - `$pCallBack`: ScriptBlock executed upon expiration.
- **Example**:
  ```powershell
  [TweenWaiter]::new($null, 2.0, {
      [System.Windows.Forms.MessageBox]::Show("2 seconds have elapsed!")
  })
  ```

---

## 📐 Easing Algorithms Reference

Easing equations control the acceleration and deceleration curve of an animation over time. For visual previews of these mathematical curves, visit [easings.net](https://easings.net/).

### Easing Variations

Each algorithm family (except `Linear`) supports four distinct curve modes:

| Variation | Suffix | Description |
| :--- | :--- | :--- |
| **Ease In** | `*EaseIn` | Starts slowly and accelerates toward the end. |
| **Ease Out** | `*EaseOut` | Starts quickly and decelerates to a gentle stop. |
| **Ease In-Out** | `*EaseInOut` | Accelerates halfway through, then decelerates to the end. |
| **Ease Out-In** | `*EaseOutIn` | Decelerates during the first half, then accelerates in the second half. |

---

### Full Easing Constants Table

All constants are accessible as `$Script:ease<Name>` (or simply `$ease<Name>` in the local scope where `TweensVariables.ps1` is dot-sourced):

| Family | Variable Name | Identifier String | Mathematical Description |
| :--- | :--- | :--- | :--- |
| **Linear** | `$Script:easeLinear` | `"Linear"` | Constant speed (linear interpolation). |
| **Quad** | `$Script:easeQuadIn`<br>`$Script:easeQuadOut`<br>`$Script:easeQuadInOut`<br>`$Script:easeQuadOutIn` | `"QuadEaseIn"`<br>`"QuadEaseOut"`<br>`"QuadEaseInOut"`<br>`"QuadEaseOutIn"` | Quadratic curve ($t^2$). Smooth and subtle. |
| **Cubic** | `$Script:easeCubicIn`<br>`$Script:easeCubicOut`<br>`$Script:easeCubicInOut`<br>`$Script:easeCubicOutIn` | `"CubicEaseIn"`<br>`"CubicEaseOut"`<br>`"CubicEaseInOut"`<br>`"CubicEaseOutIn"` | Cubic curve ($t^3$). Natural acceleration. |
| **Quart** | `$Script:easeQuartIn`<br>`$Script:easeQuartOut`<br>`$Script:easeQuartInOut`<br>`$Script:easeQuartOutIn` | `"QuartEaseIn"`<br>`"QuartEaseOut"`<br>`"QuartEaseInOut"`<br>`"QuartEaseOutIn"` | Quartic curve ($t^4$). More aggressive acceleration. |
| **Quint** | `$Script:easeQuintIn`<br>`$Script:easeQuintOut`<br>`$Script:easeQuintInOut`<br>`$Script:easeQuintOutIn` | `"QuintEaseIn"`<br>`"QuintEaseOut"`<br>`"QuintEaseInOut"`<br>`"QuintEaseOutIn"` | Quintic curve ($t^5$). Pronounced snap. |
| **Sine** | `$Script:easeSineIn`<br>`$Script:easeSineOut`<br>`$Script:easeSineInOut`<br>`$Script:easeSineOutIn` | `"SineEaseIn"`<br>`"SineEaseOut"`<br>`"SineEaseInOut"`<br>`"SineEaseOutIn"` | Sinusoidal trigonometric curve. Gentle and organic. |
| **Expo** | `$Script:easeExpoIn`<br>`$Script:easeExpoOut`<br>`$Script:easeExpoInOut`<br>`$Script:easeExpoOutIn` | `"ExpoEaseIn"`<br>`"ExpoEaseOut"`<br>`"ExpoEaseInOut"`<br>`"ExpoEaseOutIn"` | Exponential curve ($2^{10(t-1)}$). Highly snappy. |
| **Circ** | `$Script:easeCircIn`<br>`$Script:easeCircOut`<br>`$Script:easeCircInOut`<br>`$Script:easeCircOutIn` | `"CircEaseIn"`<br>`"CircEaseOut"`<br>`"CircEaseInOut"`<br>`"CircEaseOutIn"` | Circular arc curve ($\sqrt{1 - t^2}$). Sudden burst and stop. |
| **Back** | `$Script:easeBackIn`<br>`$Script:easeBackOut`<br>`$Script:easeBackInOut`<br>`$Script:easeBackOutIn` | `"BackEaseIn"`<br>`"BackEaseOut"`<br>`"BackEaseInOut"`<br>`"BackEaseOutIn"` | Overshooting curve. Pulls back before moving or overshoots target. |
| **Elastic** | `$Script:easeElasticIn`<br>`$Script:easeElasticOut`<br>`$Script:easeElasticInOut`<br>`$Script:easeElasticOutIn` | `"ElasticEaseIn"`<br>`"ElasticEaseOut"`<br>`"ElasticEaseInOut"`<br>`"ElasticEaseOutIn"` | Damped spring / rubber-band oscillation. |
| **Bounce** | `$Script:easeBounceIn`<br>`$Script:easeBounceOut`<br>`$Script:easeBounceInOut`<br>`$Script:easeBounceOutIn` | `"BounceEaseIn"`<br>`"BounceEaseOut"`<br>`"BounceEaseInOut"`<br>`"BounceEaseOutIn"` | Decaying parabolic bouncing effect. |

---

## 💡 Advanced Patterns & Recipes

### Animation Chaining & Callbacks

Chain multiple animations sequentially using `setOnComplete`:

```powershell
# Move right, then change color, then move down
$p1 = [System.Drawing.Point]::new(200, 50)
$p2 = [System.Drawing.Point]::new(200, 200)

$t1 = [TweenMoveTo]::new($btn, $p1, 0.8, $Script:easeCubicOut)
$t1.setOnComplete({
    $c = [TweenColorARGB]::new($btn, "BackColor", [System.Drawing.Color]::Gray, [System.Drawing.Color]::ForestGreen, 0.5, $Script:easeLinear)
    $c.setOnComplete({
        [TweenMoveTo]::new($btn, $p2, 0.8, $Script:easeBounceOut)
    })
})
```

---

### Passing Custom Arguments to Callbacks

The callback mechanism automatically passes the **`$tweenObj`** as the first argument, followed by any additional arguments supplied via `setOnComplete($callback, $args)`:

```powershell
$myTween = [TweenMoveTo]::new($panel, [System.Drawing.Point]::new(0, 0), 1.0, $Script:easeExpoOut)

$callback = {
    param($tweenInstance, $customMessage, $nextState)
    Write-Host "Completed animation on control: $($tweenInstance.control.Name)"
    Write-Host "Message: $customMessage | State: $nextState"
}

$myTween.setOnComplete($callback, @("Panel Open Success", 1))
```

---

### Staggered Animations

Animate multiple UI controls in a staggered wave using `.setDelay()`:

```powershell
$controls = @($card1, $card2, $card3, $card4)
$baseDelay = 0.1

for ($i = 0; $i -lt $controls.Count; $i++) {
    $target = [System.Drawing.Point]::new(50, 50 + ($i * 60))
    $tw = [TweenMoveTo]::new($controls[$i], $target, 0.6, $Script:easeBackOut)
    $tw.setDelay($i * $baseDelay)
}
```

---

### Pausing, Resuming, and Cancelling

Manage active animations programmatically:

```powershell
# Pause an animation
$myTween.pause($true)

# Resume an animation
$myTween.pause($false)

# Stop and discard immediately
$myTween.stop()

# Force jump to completion immediately
$myTween.forceEnd()
```

---

### Creating Custom Tween Classes

You can easily extend the engine with your own custom tween classes:

1. **Inherit from `Tween` in `Tweens.ps1`**:
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

2. **Add a mutation handler in `TweensMovement.ps1`**:
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

3. **Register the handler in `TweensUpdater.ps1`**:
   ```powershell
   "TweenSize" { SizeControl $tween }
   ```

---

## 🎮 Running the Interactive Demo

The repository includes a feature-rich demonstration GUI (`Demo.ps1`) showcasing every easing curve, duration slider, delay configuration, and tween type in real time.

To launch the demo:

### Via Batch File:
Double-click `run.bat` or execute in terminal:
```cmd
run.bat
```

### Via PowerShell:
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\Demo.ps1
```

---

## ⚙️ Technical Notes & Best Practices

1. **WinForms Threading (STA)**: Windows Forms runs on a Single-Threaded Apartment (STA) model. All tween updates execute on the main UI thread. Avoid executing long, blocking synchronous operations (e.g., `Start-Sleep` or synchronous web requests) on the UI thread while tweens are playing to prevent frame drops.
2. **Tick Calculation vs. Real Time**: Duration is represented internally as `ticks = durationInSeconds * refreshRate`. If the UI thread is momentarily busy, ticks are incremented sequentially until completion, guaranteeing that all tweens reach their exact target destination without overshooting.
3. **Timer Cleanup**: Always invoke `$Script:tweensTimer.Stop()` and `$Script:tweensTimer.Dispose()` inside the Form's `Closing` or `FormClosed` event. Failing to do so can keep the background timer ticking in persistent PowerShell console sessions (such as PowerShell ISE or VS Code Integrated Terminal).

---

## 📄 License & Credits

- **Author**: Olivier Selliez ([olivier.selliez.dev@gmail.com](mailto:olivier.selliez.dev@gmail.com))
- **Easing Equations**: Based on Robert Penner's Easing Functions ([robertpenner.com/easing](http://robertpenner.com/easing/)).
- **License**: MIT License. Free to use, modify, and distribute for personal and commercial projects.
