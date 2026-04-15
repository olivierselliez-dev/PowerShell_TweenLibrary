<<<<<<< HEAD
<#
.SYNOPSIS
    Animation engine and update loop for the Tweening library.
.DESCRIPTION
    This script manages the central timer and the global list of active animations.
    It handles the frame-by-frame updates, delay management, and dispatching
    to specific tween type handlers.
.NOTES
    Author: Olivier Selliez
    Email: olivier.selliez.dev@gmail.com
#>

# The global list containing all active tween objects to be processed in the update loop.
=======
# The dynamic list of objets to animate :
>>>>>>> 384737f29283d1224556776a473fb5e8b177c883
[System.Collections.ArrayList]$Script:tweensList = @()

# Refresh rate per second
$Script:refreshRate = 60

<<<<<<< HEAD
# The WinForms timer used to drive the animation loop.
[System.Windows.Forms.Timer]$Script:tweensTimer = New-Object System.Windows.Forms.Timer
# The interval is calculated to match the target refresh rate.
$Script:tweensTimer.Interval = 1 / $($Script:refreshRate * 2) * 1000 #TODO: understand why *2
$Script:tweensTimer.Add_Tick({ TweensUpdate })
=======
# The timer object which call the Update funtion [refreshRate] per second
[System.Windows.Forms.Timer]$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1 / $($Script:refreshRate * 2) * 1000 #TODO: understand why *2
$timer.Add_Tick({ Update })
>>>>>>> 384737f29283d1224556776a473fb5e8b177c883

function TweensUpdate {
    <#
    .SYNOPSIS
        Processes active animations on each timer tick.
    .DESCRIPTION
<<<<<<< HEAD
        Iterates through the global list of tweens, handles individual delays, 
        and dispatches each active tween to its corresponding property update function.
=======
        Iterates through the global list of tweens and dispatches each to its 
        corresponding update function (NumericString, ProgressBar, MoveTo, or ColorARGB).
>>>>>>> 384737f29283d1224556776a473fb5e8b177c883
    #>

    if ($Script:tweensList.Count -gt 0) {
        try {
<<<<<<< HEAD
            foreach ($tween in $Script:tweensList) {
                # If a delay is set, decrement it and skip the update for this frame
                if ($tween.delay -ne 0) {
                    $tween.delay--
                }
                else {
                    switch ($tween.GetType()) {
                        "TweenNumericString" {
                            NumericString $tween
                        }
                        "TweenProgressBar" {
                            ProgressBar $tween
                        }
                        "TweenMoveTo" { 
                            MoveTo $tween
                        }
                        "TweenColorARGB" {
                            ColorARGB $tween
                        }
                        Default { Write-Host "AnimationType not handled." }
=======
            foreach ($tweenObj in $Script:tweensList) {
                switch ($tweenObj.GetType()) {
                    "TweenNumericString" {
                        NumericString $tweenObj
>>>>>>> 384737f29283d1224556776a473fb5e8b177c883
                    }
                }

                if ($Script:tweensList.Count -eq 0) {
                    break
                }

            }
        }
        catch {
            # Debug logging (optional):
            # Write-Host $_.Exception.Message -ForegroundColor Red
            
            # Error handling to prevent crash when the collection is modified 
            # during iteration (removal of completed tweens).
            # TODO : try to find a better solution
        }
    }
    
}