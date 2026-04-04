$Script:refreshRate = 60

[System.Windows.Forms.Timer]$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $($(1 / $($Script:refreshRate * 2)) * 1000)
$timer.Add_Tick({ Update })

function Update {

    if ($Script:listToAnimate.Count -gt 0) {
        try {
            foreach ($tw in $Script:listToAnimate) {

                switch ($tw.animationType) {
                    "numeric" {
                        NumericDisplay $tw
                    }
                    "moveTo" { 
                        MoveTo $tw
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