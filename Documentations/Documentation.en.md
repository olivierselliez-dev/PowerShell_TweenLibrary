# Documentation: PowerShell Animation Library (Tweens)

This library allows for the integration of fluid animations into **Windows Forms** interfaces.

## Architecture

- **Tweens.ps1**: Defines the classes (`TweenMoveTo`, `TweenColorARGB`, etc.).
- **TweensUpdater.ps1**: Rendering engine (Update Loop).
- **TweensVariables.ps1**: Easing constants.

## Quick Start

1. Initialize the global list:
   ```powershell
   $Script:listToAnimate = New-Object System.Collections.ArrayList
   ```

2. Create an animation:
   ```powershell
   $anim = [TweenMoveTo]::new($myControl, $destination, $durationSec, $easingType)
   $Script:listToAnimate.Add($anim)
   ```

## Available Classes

### TweenMoveTo
Animates the `Location` position of a control.
- **Parameters**: `Control`, `Point` (Destination), `Double` (Duration), `String` (Easing).

### TweenColorARGB
Transitions between two colors (`ForeColor` or `BackColor`).
- **Parameters**: `Control`, `String` (Property), `Color` (Start), `Color` (End), `Double` (Duration), `String` (Easing).

### TweenNumericString
Animates a numeric value within a label's text.
- **Parameters**: `Control`, `String` (Type: int/double), `Double` (Start), `Double` (End), `Double` (Duration), `String` (Easing).

### TweenProgressBar
Animates the progress of a `ProgressBar`.
- **Parameters**: `ProgressBar`, `Double` (Start), `Double` (End), `Double` (Duration), `String` (Easing).

## Easing Functions

Easing variables are accessible via the `$Script:` scope (e.g., `$Script:easeBounceOut`).
Main types:
- `Linear`
- `Expo`
- `Bounce`
- `Elastic`
- `Back`

## Performance

The engine runs by default at 60 FPS (`$Script:refreshRate = 60`).

> **Important Note**: Ensure that the timer is properly disposed of when closing the form:
> ```powershell
> $mainForm.Add_Closing({ $timer.Dispose() })
> ```

---
*Documentation generated for the PowerShell Tweens project.*