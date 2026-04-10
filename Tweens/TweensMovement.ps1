function NumericString {
    <#
    .SYNOPSIS
        Updates the text property of a control for numeric animations.
    .DESCRIPTION
        Calculates the current numeric value based on the elapsed ticks and the chosen easing function. 
        Updates the target control's text property, formatting it as either an integer or a double.
    .PARAMETER tweenObj
        The TweenNumericVal object containing the animation state and configuration.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TweenNumericString]
        $tweenObj
    )

    $tweenObj.nbTicks++
    
    if ($tweenObj.nbTicks -gt $tweenObj.duration) {
        # animation ended

        # Remove the tweenObject from the list of tweenObjects to animate
        $Script:listToAnimate.Remove($tweenObj)

        # Log some stuff
        Write-Host $tweenObj.control.Name "animation ends. Duration :" $($(Get-Date) - $animationStartTime) "(supposed duration :" $($tweenObj.duration / $refreshRate) "sec.)"
   
        # Execute callback if defined
        if ($null -ne $tweenObj.onComplete) {
            & $tweenObj.onComplete
        }

    }
    else {
        $val = Ease $tweenObj.easing $tweenObj.startValue $tweenObj.delta $tweenObj.nbTicks $tweenObj.duration
       
        if ($tweenObj.type -eq "double") {
            $tweenObj.control.Text = [Math]::Round($val, 2).ToString()
        }
        else {
            $tweenObj.control.Text = [Math]::Floor($val).ToString()
        }
    }
    
}

function ProgressBar {
    <#
    .SYNOPSIS
        Updates the value of a ProgressBar control during an animation.
    .DESCRIPTION
        Calculates the current progress value based on elapsed ticks and the easing function. 
        Updates the target ProgressBar's Value property.
    .PARAMETER tweenObj
        The TweenNumericVal object containing the animation state and the ProgressBar control.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TweenProgressBar]
        $tweenObj
    )

    $tweenObj.nbTicks++
    
    if ($tweenObj.nbTicks -gt $tweenObj.duration) {
        # animation ended

        # Remove the tweenObject from the list of tweenObjects to animate
        $Script:listToAnimate.Remove($tweenObj)

        # Log some stuff
        Write-Host $tweenObj.control.Name "animation ends. Duration :" $($(Get-Date) - $animationStartTime) "(supposed duration :" $($tweenObj.duration / $refreshRate) "sec.)"
   
        # Execute callback if defined
        if ($null -ne $tweenObj.onComplete) {
            & $tweenObj.onComplete
        }

    }
    else {
        $val = Ease $tweenObj.easing $tweenObj.startValue $tweenObj.delta $tweenObj.nbTicks $tweenObj.duration
        $tweenObj.control.Value = $val
    }

}

function MoveTo {
    <#
    .SYNOPSIS
        Updates the location of a control for movement animations.
    .DESCRIPTION
        Calculates the current X and Y coordinates using the specified easing algorithm and updates 
        the control's position on the form.
    .PARAMETER tweenObj
        The TweenMoveTo object containing the animation state, destination, and configuration.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TweenMoveTo]
        $tweenObj
    )

    $tweenObj.nbTicks++
    
    if ($tweenObj.nbTicks -gt $tweenObj.duration) {
        # animation ended
        
        # Fix the position to the destination
        $tweenObj.control.Location = [System.Drawing.Point]::new($tweenObj.destPos.X, $tweenObj.destPos.Y)
        
        # Remove the tweenObject from the list of tweenObjects to animate
        $Script:listToAnimate.Remove($tweenObj)

        # Log some stuff
        Write-Host $tweenObj.control.Name "animation ends. Duration :" $($(Get-Date) - $animationStartTime) "(supposed duration :" $($tweenObj.duration / $refreshRate) "sec.)"
   
        # Execute callback if defined
        if ($null -ne $tweenObj.onComplete) {
            & $tweenObj.onComplete
        }

    }
    else {
        # TODO Find a way to avoid the "new"
        [System.Drawing.Point]$currentPos = [System.Drawing.Point]::new(0, 0)

        $currentPos.X = Ease $tweenObj.easing $tweenObj.startPos.X $tweenObj.delta.X $tweenObj.nbTicks $tweenObj.duration
        $currentPos.Y = Ease $tweenObj.easing $tweenObj.startPos.Y $tweenObj.delta.Y $tweenObj.nbTicks $tweenObj.duration

        $tweenObj.control.Location = $currentPos
    }

}

function ColorARGB {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [TweenColorARGB]
        $tweenObj
    )

    $tweenObj.nbTicks++
    
    if ($tweenObj.nbTicks -gt $tweenObj.duration) {
        # animation ended
        
        # Remove the tweenObject from the list of tweenObjects to animate
        $Script:listToAnimate.Remove($tweenObj)

        # Log some stuff
        Write-Host $tweenObj.control.Name "animation ends. Duration :" $($(Get-Date) - $animationStartTime) "(supposed duration :" $($tweenObj.duration / $refreshRate) "sec.)"
   
        # Execute callback if defined
        if ($null -ne $tweenObj.onComplete) {
            & $tweenObj.onComplete
        }

    }
    else {
        switch ($tweenObj.control.GetType()) {

            "System.Windows.Forms.Label" { 

                [System.Windows.Forms.Label]$label = $tweenObj.control

                $A = Ease $tweenObj.easing $tweenObj.startColor.A $tweenObj.deltaA $tweenObj.nbTicks $tweenObj.duration
                $R = Ease $tweenObj.easing $tweenObj.startColor.R $tweenObj.deltaR $tweenObj.nbTicks $tweenObj.duration
                $G = Ease $tweenObj.easing $tweenObj.startColor.G $tweenObj.deltaG $tweenObj.nbTicks $tweenObj.duration
                $B = Ease $tweenObj.easing $tweenObj.startColor.B $tweenObj.deltaB $tweenObj.nbTicks $tweenObj.duration

                if ($tweenObj.type -eq "ForeColor") {
                    $label.ForeColor = [System.Drawing.Color]::FromArgb($A, $R, $G, $B)
                }
                else { #BackColor
                    $label.BackColor = [System.Drawing.Color]::FromArgb($A, $R, $G, $B)
                }
            }
            
            Default {
                Write-Host "This type of control is not yet handled. Please implement it."
            }

        }
    }

}

function Ease {
    <#
    .SYNOPSIS
        Core mathematical engine for easing functions.
    .DESCRIPTION
        Calculates the intermediate value of a property at a specific point in time (tick) using 
        standard Robert Penner easing equations. Supports Linear, Expo, Circ, Quad, Sine, Cubic, 
        Quart, Quint, Elastic, Bounce, and Back algorithms with In, Out, InOut, and OutIn variations.
    .PARAMETER type
        The string identifier of the easing function to use.
    .PARAMETER startValue
        The value at the beginning of the animation.
    .PARAMETER endValue
        The total change in value over the duration (Delta).
    .PARAMETER currentTick
        The current progress of the animation in ticks.
    .PARAMETER duration
        The total duration of the animation in ticks.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $type,

        [Parameter(Mandatory = $true)]
        [Double]
        $startValue,

        [Parameter(Mandatory = $true)]
        [Double]
        $endValue,

        [Parameter(Mandatory = $true)]
        [Double]
        $currentTick,

        [Parameter(Mandatory = $true)]
        [Double]
        $duration
    )

    switch ($type) {
        #region Linear
        $easeLinear {
            return $endValue * $currentTick / $duration + $startValue
        }
        #endregion
        #region Expo
        $easeExpoOut {
            if ($currentTick -eq $duration) {
                return $startValue + $endValue
            }
            else {
                return $endValue * ( - [Math]::Pow(2, -10 * $currentTick / $duration) + 1) + $startValue
            }
        }
        $easeExpoIn {
            if ($currentTick -eq 0) {
                return $startValue
            }
            else {
                return $endValue * [Math]::Pow(2, 10 * ($currentTick / $duration - 1)) + $startValue
            }
        }
        $easeExpoInOut {
            if ($currentTick -eq 0) {
                return $startValue
            }
            if ($currentTick -eq $duration) {
                return $startValue + $endValue
            }

            $currentTick = $currentTick / ($duration / 2)
            if ($currentTick -lt 1) {
                return $endValue / 2 * [Math]::Pow(2, 10 * ($currentTick - 1)) + $startValue
            }
            else {
                $currentTick--
                return $endValue / 2 * ( - [Math]::Pow(2, -10 * $currentTick) + 2) + $startValue
            }
        }
        $easeExpoOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeExpoOut $startValue $($endValue / 2) $($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeExpoIn  $($startValue + $($endValue / 2)) $($endValue / 2) $($($currentTick * 2) - $duration) $duration)
            }
        }
        #endregion
        #region Circ
        $easeCircOut {
            $tempCurrentTick = ($currentTick / $duration) - 1
            return $endValue * [Math]::Sqrt(1 - ($tempCurrentTick * $tempCurrentTick)) + $startValue
        }
        $easeCircIn {
            $ratio = $currentTick / $duration
            return - $endValue * ([Math]::Sqrt(1 - ($ratio * $ratio)) - 1) + $startValue
        }
        $easeCircInOut {
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return - $endValue / 2 * ([Math]::Sqrt(1 - $currentTick * $currentTick) - 1) + $startValue
            }
            else {
                return $endValue / 2 * ([Math]::Sqrt(1 - ($currentTick -= 2) * $currentTick) + 1) + $startValue
            }
        }
        $easeCircOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeCircOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeCircIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Quad
        $easeQuadOut {
            return - $endValue * ($currentTick /= $duration) * ($currentTick - 2) + $startValue
        }
        $easeQuadIn {
            return $endValue * ($currentTick /= $duration) * $currentTick + $startValue
        }
        $easeQuadInOut {
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return $endValue / 2 * $currentTick * $currentTick + $startValue
            }
            else {
                --$currentTick
                return - $endValue / 2 * ($currentTick * ($currentTick - 2) - 1) + $startValue
            }
        }
        $easeQuadOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeQuadOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeQuadIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }   
        }
        #endregion
        #region Sine
        $easeSineOut {
            return $endValue * [Math]::Sin($currentTick / $duration * ([Math]::PI / 2)) + $startValue
        }
        $easeSineIn {
            return - $endValue * [Math]::Cos($currentTick / $duration * ([Math]::PI / 2)) + $endValue + $startValue
        }
        $easeSineInOut {
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return $endValue / 2 * [Math]::Sin([Math]::PI * $currentTick / 2) + $startValue
            }
            else {
                --$currentTick
                return - $endValue / 2 * ([Math]::Cos([Math]::PI * $currentTick / 2) - 2) + $startValue
            }
            
        }
        $easeSineOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeSineOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeSineIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Cubic
        $easeCubicOut {
            return $endValue * (($currentTick = $currentTick / $duration - 1) * $currentTick * $currentTick + 1) + $startValue
        }
        $easeCubicIn {
            return $endValue * ($currentTick /= $duration) * $currentTick * $currentTick + $startValue
        }
        $easeCubicInOut {
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return $endValue / 2 * $currentTick * $currentTick * $currentTick + $startValue
            }
            else {
                return $endValue / 2 * (($currentTick -= 2) * $currentTick * $currentTick + 2) + $startValue
            }            
        }
        $easeCubicOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeCubicOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeCubicIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Quart
        $easeQuartOut {
            return - $endValue * (($currentTick = $currentTick / $duration - 1) * $currentTick * $currentTick * $currentTick - 1) + $startValue
        }
        $easeQuartIn {
            return $endValue * ($currentTick /= $duration) * $currentTick * $currentTick * $currentTick + $startValue
        }
        $easeQuartInOut {
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return $endValue / 2 * $currentTick * $currentTick * $currentTick * $currentTick + $startValue
            }
            else {
                return - $endValue / 2 * (($currentTick -= 2) * $currentTick * $currentTick * $currentTick - 2) + $startValue
            }               
        }
        $easeQuartOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeQuartOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeQuartIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Quint
        $easeQuintOut {
            return $endValue * (($currentTick = $currentTick / $duration - 1) * $currentTick * $currentTick * $currentTick * $currentTick + 1) + $startValue
        }
        $easeQuintIn {
            return $endValue * ($currentTick /= $duration) * $currentTick * $currentTick * $currentTick * $currentTick + $startValue
        }
        $easeQuintInOut {
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return $endValue / 2 * $currentTick * $currentTick * $currentTick * $currentTick * $currentTick + $startValue
            }
            else {
                return $endValue / 2 * (($currentTick -= 2) * $currentTick * $currentTick * $currentTick * $currentTick + 2) + $startValue
            }
        }
        $easeQuintOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeQuintOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeQuintIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Elastic
        $easeElasticOut {
            if (($currentTick /= $duration) -eq 1) {
                return $startValue + $endValue
            }

            $p = $duration * 0.3
            $s = $p / 4

            return ($endValue * [Math]::Pow(2, -10 * $currentTick) * [Math]::Sin(($currentTick * $duration - $s) * (2 * [Math]::PI) / $p) + $endValue + $startValue)
        }
        $easeElasticIn {
            if (($currentTick /= $duration) -eq 1) {
                return $startValue + $endValue
            }

            $p = $duration * 0.3
            $s = $p / 4

            return - ($endValue * [Math]::Pow(2, 10 * ($currentTick -= 1)) * [Math]::Sin(($currentTick * $duration - $s) * (2 * [Math]::PI) / $p)) + $startValue
        }
        $easeElasticInOut {
            if (($currentTick /= ($duration / 2)) -eq 2) {
                return $startValue + $endValue
            }

            $p = $duration * (0.3 * 1.5)
            $s = $p / 4

            if ($currentTick -lt 1) {
                return -0.5 * ($endValue * [Math]::Pow(2, 10 * ($currentTick -= 1)) * [Math]::Sin(($currentTick * $duration - $s) * (2 * [Math]::PI) / $p)) + $startValue
            }

            return $endValue * [Math]::Pow(2, -10 * ($currentTick -= 1)) * [Math]::Sin(($currentTick * $duration - $s) * (2 * [Math]::PI) / $p) * 0.5 + $endValue + $startValue
        }
        $easeElasticOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeElasticOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeElasticIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Bounce
        $easeBounceOut {
            $currentTick /= $duration

            if ($currentTick -lt (1 / 2.75)) {
                return $endValue * (7.5625 * $currentTick * $currentTick) + $startValue
            }
            elseif ($currentTick -lt (2 / 2.75)) {
                return $endValue * (7.5625 * ($currentTick -= (1.5 / 2.75)) * $currentTick + 0.75) + $startValue
            }
            elseif ($currentTick -lt (2.5 / 2.75)) {
                return $endValue * (7.5625 * ($currentTick -= (2.25 / 2.75)) * $currentTick + 0.9375) + $startValue
            }
            else {
                return $endValue * (7.5625 * ($currentTick -= (2.625 / 2.75)) * $currentTick + 0.984375) + $startValue
            }
        }
        $easeBounceIn {
            return $endValue - $(Ease $easeBounceOut 0 $endValue ($duration - $currentTick) $duration) + $startValue
        }
        $easeBounceInOut {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeBounceIn 0 $endValue ($currentTick * 2) $duration) * 0.5 + $startValue
            }
            else {
                return $(Ease $easeBounceOut 0 $endValue ($currentTick * 2 - $duration) $duration) * 0.5 + $endValue * 0.5 + $startValue
            }
        }
        $easeBounceOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeBounceOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeBounceIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        #region Back
        $easeBackOut {
            $s = 1.70158
            return $endValue * (($currentTick = $currentTick / $duration - 1) * $currentTick * (($s + 1) * $currentTick + $s) + 1) + $startValue
        }
        $easeBackIn {
            $s = 1.70158
            return $endValue * ($currentTick /= $duration) * $currentTick * (($s + 1) * $currentTick - $s) + $startValue
        }
        $easeBackInOut {
            $s = 1.70158 * 1.525
            if (($currentTick /= ($duration / 2)) -lt 1) {
                return $endValue / 2 * ($currentTick * $currentTick * (($s + 1) * $currentTick - $s)) + $startValue
            }
            else {
                return $endValue / 2 * (($currentTick -= 2) * $currentTick * (($s + 1) * $currentTick + $s) + 2) + $startValue
            }            
        }
        $easeBackOutIn {
            if ($currentTick -lt ($duration / 2)) {
                return $(Ease $easeBackOut $startValue ($endValue / 2) ($currentTick * 2) $duration)
            }
            else {
                return $(Ease $easeBackIn ($startValue + $endValue / 2) ($endValue / 2) ($currentTick * 2 - $duration) $duration)
            }
        }
        #endregion
        Default {}
    }

}