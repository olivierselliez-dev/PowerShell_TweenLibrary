# Documentation: PowerShell Animation Library (Tweens)

This library allows for the integration of fluid and performant animations into **Windows Forms** interfaces using PowerShell.

## Summary
- [Architecture](#architecture)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Available Classes](#available-classes)
- [Easing Functions](#easing-functions)
- [Performance and Best Practices](#performance)

## Architecture

- **Tweens.ps1**: Definition of main classes (`TweenMoveTo`, `TweenColorARGB`, etc.).
- **TweensUpdater.ps1**: Rendering engine managing the animation loop (`Update`).
- **TweensVariables.ps1**: Mathematical constants for easing curves.

## Installation

To use the library, you must "dot-source" the files into your main script:

```powershell
. "$PSScriptRoot\TweensVariables.ps1"
. "$PSScriptRoot\Tweens.ps1"
. "$PSScriptRoot\TweensUpdater.ps1"
```

## Quick Start

1. **Initialization**: Create the list that will hold active animations.
   ```powershell
   $Script:listToAnimate = New-Object System.Collections.ArrayList
   ```

2. **Creation**: Instantiate a Tween object and add it to the list.
   ```powershell
   $destination = New-Object System.Drawing.Point(100, 100)
   $callback = { Write-Host "Animation Done!" }
   $anim = [TweenMoveTo]::new($myControl, $destination, 0.5, $Script:easeOutExpo, $callback)
   $Script:listToAnimate.Add($anim)
   ```

## Available Classes

### TweenMoveTo
Animates the `Location` position of a control.
- **Parameters**: `Control`, `Point` (Destination), `Double` (Duration), `String` (Easing), `ScriptBlock` (Optional: Callback).

### TweenColorARGB
Transitions between two colors (`ForeColor` or `BackColor`).
- **Parameters**: `Control`, `String` (Property), `Color` (Start), `Color` (End), `Double` (Duration), `String` (Easing), `ScriptBlock` (Optional: Callback).

### TweenNumericString
Animates a numeric value within a label's text.
- **Parameters**: `Control`, `String` (Type: int/double), `Double` (Start), `Double` (End), `Double` (Duration), `String` (Easing), `ScriptBlock` (Optional: Callback).

### TweenProgressBar
Animates the progress of a `ProgressBar`.
- **Parameters**: `ProgressBar`, `Double` (Start), `Double` (End), `Double` (Duration), `String` (Easing), `ScriptBlock` (Optional: Callback).

## Easing Functions

Easing variables are accessible via the `$Script:` scope (e.g., `$Script:easeBounceOut`). You can view visual examples of these curves at easings.net.

Main types:
- `Linear`
- `Expo`
- `Bounce`
- `Elastic`
- `Back`

## Performance

The engine is optimized to run at **60 FPS** (`$Script:refreshRate = 60`).

### Recommendations:
- **Cleanup**: Finished animations are automatically removed from the list by the engine to save resources.
- **Timer Management**: It is mandatory to stop and dispose of the WinForms Timer when closing the form to prevent memory leaks.

```powershell
$mainForm.Add_Closing({ 
    $timer.Stop()
    $timer.Dispose() 
})
```

---
*Documentation generated for the PowerShell Tweens project.*