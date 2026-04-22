<#
.SYNOPSIS
    Library of tweening classes for Windows Forms animations.
.DESCRIPTION
    This script defines a collection of classes used to handle different types of animations (Tweens). 
    It includes a base class for common animation logic and specialized classes for animating 
    control positions, numeric text values, progress bar levels, and ARGB colors.
.NOTES
    Author: Olivier Selliez
    Email: olivier.selliez.dev@gmail.com
#>

<#
.SYNOPSIS
    Base class for all tween animations.
.DESCRIPTION
    Provides the core structure for tracking animation progress, duration, and easing state.
#>
class Tween {

    # The control object targeted by this tween animation.
    [System.Object]$control

    # The name of the easing function to apply to the animation (e.g., "Linear", "ExpoEaseOut").
    [string]$easing

    # The number of ticks (frames) that have passed since the animation started.
    # This is used to track progress through the animation duration.
    [int]$nbTicks

    # The DateTime when the animation officially started, used for precise duration calculation and logging.
    [DateTime]$startTime

    # The total duration of the animation in seconds.
    [double]$duration

    # ScriptBlock to execute when the animation completes.
    [ScriptBlock]$onComplete

    # The delay before the animation starts, in seconds.
    [int]$delay

    Tween () {
        <#
        .SYNOPSIS
            Initializes a new instance of the Tween class.
        .DESCRIPTION
            This constructor sets the initial state for a new tween animation,
            including resetting tick count, clearing the onComplete callback,
            and setting the delay to zero. It also records the start time
            for logging purposes.
        #>
        $this.nbTicks = 0
        $this.onComplete = $null
        $this.delay = 0
        $this.startTime = Get-Date # just used for logs 
    }

    [void]setOnComplete([scriptblock]$pCallBack) {
        <#
        .SYNOPSIS
            Sets a callback function to be executed when the tween animation completes.
        #>
        $this.onComplete = $pCallBack
    }

    [void]setDelay([int]$pDelay) {
        <#
        .SYNOPSIS
            Sets a delay before the tween animation begins.
        .DESCRIPTION
            The delay is specified in seconds and is converted into internal ticks
            based on the global refresh rate.
        .PARAMETER pDelay
            The delay duration in seconds.
        #>
        $this.delay = $pDelay * $Script:refreshRate
    }

    [void]forceEnd() {
        <#
        .SYNOPSIS
            Forces the animation to immediately end.
        .DESCRIPTION
            This method sets the delay to zero and advances the animation's
            tick count to its maximum duration, effectively completing it
            on the next update cycle.
        #>
        $this.delay = 0
        $this.nbTicks = $this.duration * $Script:refreshRate
    }
}

<#
.SYNOPSIS
    Tween class for animating numeric values represented as strings.
.DESCRIPTION
    Inherits from Tween to manage transitions between two numeric values (int or double), 
    typically used for updating text labels.
#>
class TweenNumericString : Tween {
    
    # The type of value to display: "double" (rounds to 2 decimal places) or "int" (default).
    [string]$type # double or int (default)
    
    # The starting numeric value for the animation.
    [double]$startValue
    
    # The target numeric value for the animation.
    [double]$endValue
    
    # The total change in value from startValue to endValue.
    [double]$delta
        
    TweenNumericString([System.Windows.Forms.Control]$pControl, [string]$pType, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenNumericString.
        .DESCRIPTION
            This constructor sets up an animation for a numeric value displayed as a string
            on a control. It validates the numeric type and calculates the total change
            (delta) for the animation.
        .PARAMETER pControl
            The control object to be updated.
        .PARAMETER pType
            The numeric type for the value ('int' or 'double').
        .PARAMETER pStartValue
            The starting numeric value.
        .PARAMETER pEndValue
            The target numeric value.
        .PARAMETER pDuration
            The duration of the animation in seconds.
        .PARAMETER pEasing
            The name of the easing function to apply.
        #>
        if ($pType -notin @('int', 'double')) {
            throw "Invalid numeric type '$pType'. Supported values are 'int' or 'double'."
        }

        $this.control = $pControl
        $this.type = $pType.ToLower()
        $this.easing = $pEasing
        $this.startValue = $pStartValue
        $this.endValue = $pEndValue
        $this.duration = $pDuration * $Script:refreshRate

        $this.delta = $this.endValue - $this.startValue
    }

}

<#
.SYNOPSIS
    Tween class for animating control movement.
.DESCRIPTION
    Inherits from Tween to transition a control's Location property from one point to another.
#>
class TweenMoveTo : Tween {
   
    # The starting position (X, Y coordinates) of the control.
    [System.Drawing.Point]$startPos
    
    # The destination position (X, Y coordinates) for the control.
    [System.Drawing.Point]$destPos
    
    # The total change in position (X, Y coordinates) from startPos to destPos.
    [System.Drawing.Point]$delta
    
    TweenMoveTo([System.Windows.Forms.Control]$pControl, [System.Drawing.Point]$pDestPos, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenMoveTo.
        .DESCRIPTION
            This constructor prepares a tween animation to move a specified control
            from its current location to a new destination point over a given duration,
            using a defined easing function.
        .PARAMETER pControl
            The control to move.
        .PARAMETER pDestPos
            The destination Point.
        .PARAMETER pDuration
            The duration of the movement in seconds.
        .PARAMETER pEasing
            The name of the easing function to apply.
        #>
        $this.control = $pControl
        $this.easing = $pEasing
        $this.destPos = $pDestPos
        $this.duration = $pDuration * $Script:refreshRate

        $this.startPos = [System.Drawing.Point]::new($pControl.Location.X, $pControl.Location.Y)
        $this.delta = [System.Drawing.Point]::new($this.destPos.X - $this.startPos.X, $this.destPos.Y - $this.startPos.Y)
    }

}

<#
.SYNOPSIS
    Tween class for ProgressBar value transitions.
.DESCRIPTION
    Inherits from Tween to animate the 'Value' property of a System.Windows.Forms.ProgressBar.
#>
class TweenProgressBar : Tween {

    # The initial value of the ProgressBar.
    [double]$startValue
    
    # The target value of the ProgressBar.
    [double]$endValue
    
    # The total change in value from startValue to endValue for the ProgressBar.
    [double]$delta

    TweenProgressBar([System.Windows.Forms.ProgressBar]$pProgressBar, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenProgressBar.
        .DESCRIPTION
            This constructor sets up an animation for a ProgressBar control,
            transitioning its value from a starting percentage to an ending percentage
            over a specified duration with a given easing function.
        .PARAMETER pProgressBar
            The target ProgressBar control.
        .PARAMETER pStartValue
            The initial percentage value.
        .PARAMETER pEndValue
            The target percentage value.
        .PARAMETER pDuration
            The duration in seconds.
        .PARAMETER pEasing
            The name of the easing function to apply.
        #>
        $this.control = $pProgressBar
        $this.startValue = $pStartValue
        $this.endValue = $pEndValue
        $this.duration = $pDuration * $Script:refreshRate
        $this.easing = $pEasing

        $this.delta = $pEndValue - $pStartValue
    }

}

<#
.SYNOPSIS
    Tween class for ARGB color transitions.
.DESCRIPTION
    Inherits from Tween to animate color properties such as BackColor or ForeColor using ARGB channels.
#>
class TweenColorARGB : Tween {

    # The starting color for the animation.
    [System.Drawing.Color]$startColor
    
    # The target color for the animation.
    [System.Drawing.Color]$endColor
    
    # The total change in the Alpha channel (opacity) from startColor to endColor.
    [double]$deltaA
    
    # The total change in the Red channel from startColor to endColor.
    [double]$deltaR
    
    # The total change in the Green channel from startColor to endColor.
    [double]$deltaG
    
    # The total change in the Blue channel from startColor to endColor.
    [double]$deltaB
    
    # The property name of the color to change (e.g., "BackColor" or "ForeColor").
    [string]$type # "BackColor" or "ForeColor" (default)

    TweenColorARGB([System.Windows.Forms.Control]$pControl, [string]$pType, [System.Drawing.Color]$pStartColor, [System.Drawing.Color]$pEndColor, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenColorARGB.
        .DESCRIPTION
            This constructor creates a tween animation for a color property (like ForeColor or BackColor)
            of a control, transitioning it from a starting color to an ending color over a specified
            duration with a given easing function. It calculates the delta for each ARGB channel.
        .PARAMETER pControl
            The control whose color will be animated.
        .PARAMETER pType
            The property name to animate ('BackColor' or 'ForeColor').
        .PARAMETER pStartColor
            The starting Color.
        .PARAMETER pEndColor
            The target Color.
        .PARAMETER pDuration
            The duration in seconds.
        .PARAMETER pEasing
            The name of the easing function to apply.
        #>
        
        $this.control = $pControl
        $this.type = $pType
        $this.startColor = $pStartColor
        $this.endColor = $pEndColor
        $this.duration = $pDuration * $Script:refreshRate
        $this.easing = $pEasing
        
        $this.deltaA = $pEndColor.A - $pStartColor.A
        $this.deltaR = $pEndColor.R - $pStartColor.R
        $this.deltaG = $pEndColor.G - $pStartColor.G
        $this.deltaB = $pEndColor.B - $pStartColor.B
    }

}

class TweenWaiter : Tween {

    TweenWaiter([System.Object]$pControl, [double]$pDuration, [scriptblock]$pCallBack) {
        $this.control = $pControl
        $this.duration = $pDuration * $Script:refreshRate
        $this.onComplete = $pCallBack

        $Script:tweensList.Add($this) | Out-Null
    }

}