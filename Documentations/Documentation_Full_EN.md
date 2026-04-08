# PowerShell Tweens Library Documentation

A lightweight, class-based animation engine for **Windows Forms** in PowerShell. This library implements Robert Penner's easing equations to provide smooth, non-linear transitions for UI elements.

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
Initialize the required global variables and the timer:
```powershell
# Set target framerate
$Script:refreshRate = 60 

# Initialize the animation queue
$Script:listToAnimate = New-Object System.Collections.ArrayList

# Start the timer when the form is shown
$mainForm.Add_Shown({ $timer.Start() })

# CRITICAL: Dispose the timer on close to prevent memory leaks in the PowerShell session
$mainForm.Add_Closing({ $timer.Dispose() })
```

---

## 3. Tween Class Reference

All animations inherit from the base `Tween` class, which tracks `nbTicks` (progress) and `duration` (total length in frames).

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
- **Type**: `"int"` (rounds down) or `"double"` (rounds to 2 decimals).

### `TweenProgressBar`
Animates the `Value` property of a `System.Windows.Forms.ProgressBar`.
- **Constructor**: `[TweenProgressBar]::new($ProgressBar, $StartVal, $EndVal, $DurationSec, $Easing)`

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
The `Update` function in `TweensUpdater.ps1` runs every tick. It iterates through `$Script:listToAnimate`. When a tween reaches its duration, it is automatically removed from the list.

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

# Add to the engine
$Script:listToAnimate.Add($myTween)
```

---
*Documentation generated for the PowerShell Tweens project.*
