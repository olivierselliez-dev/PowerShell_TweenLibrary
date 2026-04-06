class Tween {

    [System.Object]$control
    [string]$animationType
    [string]$easing
    [int]$nbTicks
    [DateTime]$startTime
    [double]$duration

}

class TweenNumericVal : Tween {
    
    [string]$type # double or int (default)
    [double]$startValue
    [double]$endValue
    [double]$delta
    
    TweenNumericVal([System.Object]$obj, [string]$animType, [string]$t, [double]$startVal, [double]$endVal, [double]$dur, [string]$pEasing) {
        $this.control = $obj
        $this.animationType = $animType
        $this.type = $t
        $this.easing = $pEasing
        $this.startValue = $startVal
        $this.endValue = $endVal
        $this.duration = $dur * $Script:refreshRate

        $this.delta = $this.endValue - $this.startValue
        $this.nbTicks = 0
        $this.startTime = Get-Date
    }
}

class TweenMoveTo : Tween {
   
    [System.Drawing.Point]$startPos
    [System.Drawing.Point]$destPos
    [System.Drawing.Point]$delta

    TweenMoveTo([System.Object]$obj, [string]$animType, [System.Drawing.Point]$dest, [double]$dur, [string]$pEasing) {
        $this.control = $obj
        $this.animationType = $animType
        $this.easing = $pEasing
        $this.destPos = $dest
        $this.duration = $dur * $Script:refreshRate

        $this.startPos = [System.Drawing.Point]::new($obj.Location.X, $obj.Location.Y)
        $this.delta = [System.Drawing.Point]::new($this.destPos.X - $this.startPos.X, $this.destPos.Y - $this.startPos.Y)
        $this.nbTicks = 0
        $this.startTime = Get-Date
    }

}