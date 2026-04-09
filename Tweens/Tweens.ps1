<#
.SYNOPSIS
    Library of tweening classes for Windows Forms animations.
.DESCRIPTION
    This script defines a collection of classes used to handle different types of animations (Tweens). 
    It includes a base class for common animation logic and specialized classes for animating 
    control positions, numeric text values, progress bar levels, and ARGB colors.
#>

using namespace System.Windows.Forms

<#
.SYNOPSIS
    Base class for all tween animations.
.DESCRIPTION
    Provides the core structure for tracking animation progress, duration, and easing state.
#>
class Tween {

    <#
    .NOTES
        The control object targeted by this tween animation.
    #>
    [System.Object]$control
    <#
    .NOTES
        The name of the easing function to apply to the animation (e.g., "Linear", "ExpoEaseOut").
    #>
    [string]$easing
    <#
    .NOTES
        The number of ticks (frames) that have passed since the animation started.
        This is used to track progress through the animation duration.
    #>
    [int]$nbTicks
    <#
    .NOTES
        The DateTime when the animation officially started, used for precise duration calculation and logging.
    #>
    [DateTime]$startTime
    <#
    .NOTES
        The total duration of the animation in internal ticks (not necessarily seconds).
    #>
    [double]$duration

    Tween () {
        <#
        .SYNOPSIS
            Initializes a new instance of the Tween class.
        #>
        $this.nbTicks = 0 # probably useless, I guess the default value of int is 0
        $this.startTime = Get-Date # just used for logs 
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
    
    [string]$type # double or int (default)
    [double]$startValue
    <#
    .NOTES
        The starting numeric value for the animation.
    #>
    [double]$endValue
    <#
    .NOTES
        The target numeric value for the animation.
    #>
    [double]$delta
    <#
    .NOTES
        The total change in value from startValue to endValue.
    #>
    
    TweenNumericString([System.Object]$pControl, [string]$pType, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenNumericString.
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
        $this.control = $pControl
        $this.type = $pType
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
   
    [System.Drawing.Point]$startPos
    <#
    .NOTES
        The starting position (X, Y coordinates) of the control.
    #>
    [System.Drawing.Point]$destPos
    <#
    .NOTES
        The destination position (X, Y coordinates) for the control.
    #>
    [System.Drawing.Point]$delta
    <#
    .NOTES
        The total change in position (X, Y coordinates) from startPos to destPos.
    #>

    TweenMoveTo([System.Object]$pControl, [System.Drawing.Point]$pDestPos, [double]$pDururation, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenMoveTo.
        .PARAMETER pControl
            The control to move.
        .PARAMETER pDestPos
            The destination Point.
        .PARAMETER pDururation
            The duration of the movement in seconds.
        .PARAMETER pEasing
            The name of the easing function to apply.
        #>
        $this.control = $pControl
        $this.easing = $pEasing
        $this.destPos = $pDestPos
        $this.duration = $pDururation * $Script:refreshRate

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

    [double]$startValue
    <#
    .NOTES
        The initial value of the ProgressBar.
    #>
    [double]$endValue
    <#
    .NOTES
        The target value of the ProgressBar.
    #>
    [double]$delta
    <#
    .NOTES
        The total change in value from startValue to endValue for the ProgressBar.
    #>

    TweenProgressBar([System.Windows.Forms.ProgressBar]$pProgressBar, [double]$pStartValue, [double]$pEndValue, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenProgressBar.
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

    [System.Drawing.Color]$startColor
    <#
    .NOTES
        The starting color for the animation.
    #>
    [System.Drawing.Color]$endColor
    <#
    .NOTES
        The target color for the animation.
    #>
    [double]$deltaA
    <#
    .NOTES
        The total change in the Alpha channel (opacity) from startColor to endColor.
    #>
    [double]$deltaR
    <#
    .NOTES
        The total change in the Red channel from startColor to endColor.
    #>
    [double]$deltaG
    <#
    .NOTES
        The total change in the Green channel from startColor to endColor.
    #>
    [double]$deltaB
    <#
    .NOTES
        The total change in the Blue channel from startColor to endColor.
    #>
    [string]$type # "BackColor" or "ForeColor" (default)

    TweenColorARGB([System.Object]$pControl, [string]$pType, [System.Drawing.Color]$pStartColor, [System.Drawing.Color]$pEndColor, [double]$pDuration, [string]$pEasing) {
        <#
        .SYNOPSIS
            Initializes a new instance of TweenColorARGB.
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