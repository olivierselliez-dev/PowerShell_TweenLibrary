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
[System.Collections.ArrayList]$Script:tweensList = @()

# Refresh rate per second
$Script:refreshRate = 60

# The WinForms timer used to drive the animation loop.
[System.Windows.Forms.Timer]$Script:tweensTimer = New-Object System.Windows.Forms.Timer
# The interval is calculated to match the target refresh rate.
$Script:tweensTimer.Interval = 1 / $($Script:refreshRate * 2) * 1000 #TODO: understand why *2
$Script:tweensTimer.Add_Tick({ TweensUpdate })

function TweensUpdate {
    <#
    .SYNOPSIS
        Processes active animations on each timer tick.
    .DESCRIPTION
        Iterates through the global list of tweens, handles individual delays, 
        and dispatches each active tween to its corresponding property update function.
    #>

    if ($Script:tweensList.Count -gt 0) {
        try {
            foreach ($tween in $Script:tweensList) {
                if ($tween.delay -ne 0) {
                    WaitDelay $tween
                }
                elseif (-not $tween.isPaused) {
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
                        "TweenOpacity" {
                            Opacity $tween
                        }
                        "TweenWaiter" {
                            Wait $tween
                        }
                        Default { Write-Host "AnimationType not handled." }
                    }
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