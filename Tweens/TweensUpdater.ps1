$Script:refreshRate = 60

[System.Windows.Forms.Timer]$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1 / $($Script:refreshRate * 2) * 1000 #TODO: understand why *2
$timer.Add_Tick({ Update })

function Update {
    <#
    .SYNOPSIS
        Processes active animations on each timer tick.
    .DESCRIPTION
        Iterates through the global list of tweens and dispatches each to its 
        corresponding update function (NumericDisplay, ProgressBar, or MoveTo).
    #>

    if ($Script:listToAnimate.Count -gt 0) {
        try {
            foreach ($tweenObj in $Script:listToAnimate) {
                switch ($tweenObj.GetType()) {
                    "TweenNumericString" {
                        NumericString $tweenObj
                    }
                    "TweenProgressBar" {
                        ProgressBar $tweenObj
                    }
                    "TweenMoveTo" { 
                        MoveTo $tweenObj
                    }
                    "TweenColorARGB"{
                        ColorARGB $tweenObj
                    }
                    Default { Write-Host "AnimationType not handled." }
                }

                if ($Script:listToAnimate.Count -eq 0) {
                    break
                }

            }
        }
        catch {
            # Uncomment for debug :
            # Write-Host $_.Exception.Message -ForegroundColor Red
            # Otherwise :
            # Do nothing
            # It's just to avoid an error message because the list is modified during the foreach
            # TODO : try to find a better solution
        }
    }
    
}