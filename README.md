
# PowerShell Tweens Library Documentation

*Created by **Olivier Selliez** | [olivier.selliez.dev@gmail.com](mailto:olivier.selliez.dev@gmail.com)*

A lightweight, class-based animation engine for **Windows Forms** in PowerShell. This library implements Robert Penner's easing equations to provide smooth, non-linear transitions for UI elements.

**And yes, it's quite useless but it's funny :)**

## 1. Project Architecture

The library is modularized into four core components:

| File | Role |
| :--- | :--- |
| `Tweens.ps1` | **Data Models**: Defines the PowerShel 5.1 classes for different animation types. |
| `TweensVariables.ps1` | **Constants**: Defines the string identifiers for the easing algorithms (e.g., `$easeBounceOut`). |
| `TweensMovement.ps1` | **Logic**: Contains the mathematical functions (Easing) and the specific property update logic. |
| `TweensUpdater.ps1` | **Engine**: Manages the `System.Windows.Forms.Timer` and the global update loop. |

---

## 2. Setup & Initialization

To integrate the library into your project, follow these steps:

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
- **Constructor**: `[TweenMoveTo]::new($Control, $DestPoint, $DurationSec, $Easing, $Callback)`
- **Example**: `[TweenMoveTo]::new($btn, [System.Drawing.Point]::new(100, 100), 2.0, $easeExpoOut, $null)`

### `TweenColorARGB`
Transitions a control's color channels (Alpha, Red, Green, Blue).
- **Constructor**: `[TweenColorARGB]::new($Control, $Property, $StartColor, $EndColor, $DurationSec, $Easing, $Callback)`
- **Property**: Use `"ForeColor"` or `"BackColor"`.
- **Example**: `[TweenColorARGB]::new($label, "ForeColor", [Color]::Black, [Color]::Red, 1.5, $easeLinear, $null)`

### `TweenNumericString`
Animates a numeric value inside a control's `Text` property.
- **Constructor**: `[TweenNumericString]::new($Control, $Type, $StartVal, $EndVal, $DurationSec, $Easing, $Callback)`
- **Type**: Supports `"int"` (floored) or `"double"` (rounded to 2 decimals).
- **Example**: `$t = [TweenNumericString]::new($label, "int", 0, 100, 5.0, $easeQuadIn, { code block })`

### `TweenProgressBar`
Animates the `Value` property of a `System.Windows.Forms.ProgressBar`.
- **Constructor**: `[TweenProgressBar]::new($ProgressBar, $StartVal, $EndVal, $DurationSec, $Easing, $Callback)`

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
# Passing a scriptblock as a callback
$myTween = [TweenMoveTo]::new($btnSubmit, $destination, 3.0, $Script:easeBounceOut, { [System.Windows.Forms.MessageBox]::Show("Animation Done!") })

# Add to the engine
$Script:listToAnimate.Add($myTween)
```

---
*Documentation generated for the PowerShell Tweens project.*
