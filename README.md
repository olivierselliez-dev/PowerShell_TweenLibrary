
# PowerShell Tweens Library Documentation

*Created by **Olivier Selliez** | [olivier.selliez.dev@gmail.com](mailto:olivier.selliez.dev@gmail.com)*

A lightweight, class-based animation engine for **Windows Forms** in PowerShell. This library implements Robert Penner's easing equations to provide smooth, non-linear transitions for UI elements.

**And yes, it's quite useless but it's funny :)**

## Features

- **Robert Penner's Easing**: Includes all standard easing functions (Elastic, Bounce, Back, Expo, etc.).
- **Class-Based**: Built using PowerShell 5.1 classes for performance and structure.
- **Lightweight**: Zero external dependencies other than System.Windows.Forms.
- **Extensible**: Easily add new tween types by inheriting from the base `Tween` class.
- **Event Driven**: Built-in support for callbacks and delays.

## 1. Project Architecture

The library is modularized into four core components:

| File | Role |
| :--- | :--- |
| `Tweens.ps1` | **Data Models**: Defines the PowerShel 5.1 classes for different animation types. |
| `TweensVariables.ps1` | **Constants**: Defines the string identifiers for the easing algorithms (e.g., `$easeBounceOut`). |
| `TweensMovement.ps1` | **Logic**: Contains the mathematical functions (Easing) and the specific property update logic. |
| `TweensUpdater.ps1` | **Engine**: Manages the `System.Windows.Forms.Timer` and the global update loop. |

---

## 2. Getting Started

To integrate the library into your project, follow these steps:

### Prerequisites
- Windows PowerShell 5.1 or PowerShell 7+ (Desktop/Windows compatible).
- `System.Windows.Forms` and `System.Drawing` assemblies (usually loaded by default in WinForms scripts).

### Dot-Sourcing
Import the library files at the start of your script:
```powershell
. "$PSScriptRoot\Tweens\TweensVariables.ps1"
. "$PSScriptRoot\Tweens\Tweens.ps1"
. "$PSScriptRoot\Tweens\TweensUpdater.ps1"
. "$PSScriptRoot\Tweens\TweensMovement.ps1"
```

### Engine Configuration
```powershell
# Start the timer when the form is shown
$mainForm.Add_Shown({ 
        $Script:tweensTimer.Start()
    })

# CRITICAL: Dispose the timer on close to prevent memory leaks in the PowerShell session
$mainForm.Add_Closing({ 
        $Script:tweensTimer.Stop()
        $Script:tweensTimer.Dispose() 
    })
```
# Remarks
You can change the refresh rate in the: \Tweens\TweensUpdater.ps1 file (var:```$Script:refreshRate = 60```, line 5). By default the view is refreshed 60 times per second.
The global list used to store active animations is `$Script:tweensList` (defined in `TweensUpdater.ps1`).

---

## 3. Tween Class Reference

All animations inherit from the base `Tween` class, which tracks `nbTicks` (progress) and `duration` in seconds (converted to internal ticks).

### `TweenMoveTo`
Animates the `Location` property (X, Y) of a control.
- **Constructor**: `[TweenMoveTo]::new($Control, $DestPoint, $DurationSec, $Easing)`
- **Example**: `[TweenMoveTo]::new($btn, [System.Drawing.Point]::new(100, 100), 2.0, $easeExpoOut)`

### `TweenColorARGB`
Transitions a control's color channels (Alpha, Red, Green, Blue).
- **Constructor**: `[TweenColorARGB]::new($Control, $Property, $StartColor, $EndColor, $DurationSec, $Easing)`
- **Property**: Use `"ForeColor"` or `"BackColor"`.
- **Example**: `[TweenColorARGB]::new($label, "ForeColor", [Color]::Black, [Color]::Red, 1.5, $easeLinear)`

### `TweenNumericString`
Animates a numeric value inside a control's `Text` property.
- **Constructor**: `[TweenNumericString]::new($Control, $Type, $StartVal, $EndVal, $DurationSec, $Easing)`
- **Type**: Supports `"int"` (floored) or `"double"` (rounded to 2 decimals).
- **Example**: `$t = [TweenNumericString]::new($label, "int", 0, 100, 5.0, $easeQuadIn)`

### `TweenProgressBar`
Animates the `Value` property of a `System.Windows.Forms.ProgressBar`.
- **Constructor**: `[TweenProgressBar]::new($ProgressBar, $StartVal, $EndVal, $DurationSec, $Easing)`

### `TweenWaiter`
Executes a callback after a specified duration without modifying control properties. Useful for sequencing.
- **Constructor**: `[TweenWaiter]::new($Control, $DurationSec)`
- **Example**: `[TweenWaiter]::new($null, 1.5)`

### Common Methods
All tween objects provide the following methods to refine animation behavior:

| Method | Description | Example |
| :--- | :--- | :--- |
| `setDelay([double]$seconds)` | Sets a delay before the animation starts. | `$t.setDelay(0.5)` |
| `setOnComplete([scriptblock]$callback)` | Defines code to run after completion. | `$t.setOnComplete({ Write-Host "Done" })` |
| `forceEnd()` | Jumps to the final state and triggers callback. | `$t.forceEnd()` |

**Example with chaining:**
```powershell
$t = [TweenMoveTo]::new($btn, [System.Drawing.Point]::new(50, 50), 1.0, $easeQuadOut, $null)
$t.setDelay(0.2)
$t.setOnComplete({ $btn.Text = "Arrived!" })
```

---

## 4. Easing Algorithms

Easing functions determine the "feel" of the animation. Each algorithm (except Linear) supports four modes: `In`, `Out`, `InOut`, and `OutIn`. For visual demonstrations and previews of these curves, visit [easings.net](https://easings.net/).

| Type | Description |
| :--- | :--- |
| **Linear** | Constant speed transition. |
| **Quad / Cubic / Quart / Quint** | Increasingly aggressive power-based curves. |
| **Expo** | Exponential growth/decay; very snappy. |
| **Sine** | Smooth, organic sinusoidal transition. |
| **Circ** | Circular curve transition. |
| **Back** | Retracts slightly before moving or overshoots the target at the end. |
| **Elastic** | An oscillating "spring" effect. |
| **Bounce** | A realistic bouncing effect at the start or end. |

Access these using the script-scoped variables: `$Script:easeBounceOut`, `$Script:easeElasticInOut`, etc.

---

## 5. Technical Notes

### The Update Loop
The `TweensUpdate` function in `TweensUpdater.ps1` runs every tick. It iterates through `$Script:tweensList`. When a tween reaches its duration or target value, it is automatically removed from the list.

### Frame Rate vs. Real Time
The duration is calculated as `$DurationInSeconds * $refreshRate`. If the UI thread is heavily blocked, the animation might appear slower because ticks are skipped, but the library ensures the final destination is reached.

### Threading
Since Windows Forms is single-threaded (STA), the animations run on the same thread as the UI. Avoid long-running synchronous tasks during animations to prevent stuttering.

---

## 6. Practical Example

```powershell
# Move a button to (200, 200) over 3 seconds with a bounce effect
$destination = [System.Drawing.Point]::new(200, 200)
$myTween = [TweenMoveTo]::new($btnSubmit, $destination, 3.0, $Script:easeBounceOut)

# Note: The constructor automatically registers the tween to $Script:tweensList for processing.
```

---
*Documentation generated for the PowerShell Tweens project.*
