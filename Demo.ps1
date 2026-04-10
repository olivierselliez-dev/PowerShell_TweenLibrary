Add-Type -AssemblyName System.Windows.Forms

. $PSScriptRoot\Tweens\TweensVariables.ps1
. $PSScriptRoot\Tweens\Tweens.ps1
. $PSScriptRoot\Tweens\TweensUpdater.ps1
. $PSScriptRoot\Tweens\TweensMovement.ps1

#region Display

function InitmainForm {
    <#
    .SYNOPSIS
        Initializes the main application window.
    .DESCRIPTION
        Configures the base properties of the main form, including dimensions, title, and border style.
    #>
    $Script:mainForm = New-Object System.Windows.Forms.Form
    $Script:mainForm.Text = "Demo PowerShell Tween Library"
    $Script:mainForm.Width = 800
    $Script:mainForm.Height = 600
    $Script:mainForm.Margin = 0
    $Script:mainForm.AutoSize = $false
    $Script:mainForm.MaximizeBox = $false
    $Script:mainForm.MinimizeBox = $true
    $Script:mainForm.ShowInTaskbar = $true
    $Script:mainForm.FormBorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
}

function CreateAnimatedControls {
    <#
    .SYNOPSIS
        Creates the UI elements that will be animated.
    .DESCRIPTION
        Instantiates and adds labels, progress bars, and buttons to the main form to demonstrate different types of animations.
    #>

    #region animated value
    [System.Windows.Forms.Label]$labelAnimatedValue = New-Object System.Windows.Forms.Label
    $labelAnimatedValue.AutoSize = $true
    $labelAnimatedValue.Text = "Animated value:"
    $labelAnimatedValue.Location = [System.Drawing.Point]::new(10, 10)
    $Script:mainForm.Controls.Add($labelAnimatedValue)

    $Script:animatedValue = New-Object System.Windows.Forms.Label
    $Script:animatedValue.AutoSize = $true
    $Script:animatedValue.Text = "0" 
    $Script:animatedValue.Name = "'Animated Value'"
    $Script:animatedValue.Location = [System.Drawing.Point]::new($labelAnimatedValue.Location.X + $labelAnimatedValue.Width + 25, $labelAnimatedValue.Location.Y)
    $Script:mainForm.Controls.Add($Script:animatedValue)
    #endregion

    #region animated progressBar
    $Script:animatedProgressBar = New-Object System.Windows.Forms.ProgressBar
    $Script:animatedProgressBar.Width = 200
    $Script:animatedProgressBar.Height = 25
    $Script:animatedProgressBar.Name = "'Animated ProgressBar'"
    $Script:animatedProgressBar.Value = 0
    $Script:animatedProgressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
    $Script:animatedProgressBar.Location = [System.Drawing.Point]::new(10, $labelAnimatedValue.Location.Y + $labelAnimatedValue.Height + 20)
    $Script:mainForm.Controls.Add($Script:animatedProgressBar)
    #endregion

    #region colored label
    $Script:coloredLabel = New-Object System.Windows.Forms.Label
    $Script:coloredLabel.AutoSize = $true
    $Script:coloredLabel.Text = "This is a colored label"
    $Script:coloredLabel.Name = "'Colored Label'"
    $Script:coloredLabel.Location = [System.Drawing.Point]::new(10, $animatedProgressBar.Location.Y + $animatedProgressBar.Height + 20)
    $Script:mainForm.Controls.Add($Script:coloredLabel)
    #endregion

    #region colored label background
    $Script:coloredLabelBkg = New-Object System.Windows.Forms.Label
    $Script:coloredLabelBkg.AutoSize = $true
    $Script:coloredLabelBkg.Text = "This is a label with a colored background"
    $Script:coloredLabelBkg.Name = "'Colored Label Background'"
    $Script:coloredLabelBkg.ForeColor = [System.Drawing.Color]::White
    $Script:coloredLabelBkg.BackColor = [System.Drawing.Color]::Black
    $Script:coloredLabelBkg.Location = [System.Drawing.Point]::new($Script:coloredLabel.Location.X + $Script:coloredLabel.Width + 20, $animatedProgressBar.Location.Y + $animatedProgressBar.Height + 20)
    $Script:mainForm.Controls.Add($Script:coloredLabelBkg)
    #endregion

    #region animated button
    $Script:animatedBtn = New-Object System.Windows.Forms.Button
    $Script:animatedBtn.AutoSize = $true
    $Script:animatedBtn.Text = "Animated Button"
    $Script:animatedBtn.Name = "'Animated Button'"
    $Script:animatedBtn.Add_Click({ onClickAnimatedButton })
    $Script:animatedBtn.Location = [System.Drawing.Point]::new(10, $coloredLabel.Location.Y + $coloredLabel.Height + 20)
    $Script:mainForm.Controls.Add($Script:animatedBtn)
    #endregion

    #region animated label
    $Script:animatedLabel = New-Object System.Windows.Forms.Label
    $Script:animatedLabel.AutoSize = $true
    $Script:animatedLabel.Text = "This is an animated label,`nbut any controls can be animated"
    $Script:animatedLabel.Name = "'Animated Label'"
    $Script:animatedLabel.Location = [System.Drawing.Point]::new(10, $animatedBtn.Location.Y + $animatedBtn.Height + 20)
    $Script:mainForm.Controls.Add($Script:animatedLabel)
    #endregion

}

function CreateInputs {
    <#
    .SYNOPSIS
        Creates the configuration input controls.
    .DESCRIPTION
        Sets up a GroupBox containing text boxes and combo boxes to allow users to define destination, duration, and easing functions for animations.
    #>

    [System.Windows.Forms.GroupBox]$grBoxSettings
    $grBoxSettings = New-Object System.Windows.Forms.GroupBox
    $grBoxSettings.Text = "Settings:"
    $grBoxSettings.Margin = 0
    $grBoxSettings.Width = $Script:mainForm.ClientSize.Width - 10
     
    $Script:mainForm.Controls.Add($grBoxSettings)
    
    #region AnimatedValue

    [System.Windows.Forms.Label]$labelValue | Out-Null # Out-Null to avoid messages in the console
    $labelValue = New-Object System.Windows.Forms.Label
    $labelValue.AutoSize = $true
    $labelValue.Text = "`"Animated value`":"
    $labelValue.Location = [System.Drawing.Point]::new(5, 25)
    $grBoxSettings.Controls.Add($labelValue) 

    [System.Windows.Forms.Label]$labelValueFrom | Out-Null # Out-Null to avoid messages in the console
    $labelValueFrom = New-Object System.Windows.Forms.Label
    $labelValueFrom.AutoSize = $true
    $labelValueFrom.Text = "from:"
    $labelValueFrom.Location = [System.Drawing.Point]::new(162, $labelValue.Location.Y)
    $grBoxSettings.Controls.Add($labelValueFrom) 

    $Script:txtBoxValueFrom = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxValueFrom.Width = 25
    $Script:txtBoxValueFrom.Text = "0"
    $Script:txtBoxValueFrom.Location = [System.Drawing.Point]::new(194, $labelValue.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxValueFrom)
    
    [System.Windows.Forms.Label]$labelValueTo | Out-Null # Out-Null to avoid messages in the console
    $labelValueTo = New-Object System.Windows.Forms.Label
    $labelValueTo.AutoSize = $true
    $labelValueTo.Text = "to:"
    $labelValueTo.Location = [System.Drawing.Point]::new($Script:txtBoxValueFrom.Location.X + $Script:txtBoxValueFrom.Width, $labelValue.Location.Y)
    $grBoxSettings.Controls.Add($labelValueTo)

    $Script:txtBoxValueTo = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxValueTo.Width = 25
    $Script:txtBoxValueTo.Text = "0"
    $Script:txtBoxValueTo.Location = [System.Drawing.Point]::new($labelValueTo.Location.X + $labelValueTo.Width, $labelValue.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxValueTo)

    [System.Windows.Forms.Label]$labelValueDuration | Out-Null # Out-Null to avoid messages in the console
    $labelValueDuration = New-Object System.Windows.Forms.Label
    $labelValueDuration.AutoSize = $true
    $labelValueDuration.Text = "duration (sec):"
    $labelValueDuration.Location = [System.Drawing.Point]::new($Script:txtBoxValueTo.Location.X + $Script:txtBoxValueTo.Width + 20, $labelValue.Location.Y)
    $grBoxSettings.Controls.Add($labelValueDuration)

    $Script:txtBoxValueDuration = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxValueDuration.Width = 25
    $Script:txtBoxValueDuration.Text = 5
    $Script:txtBoxValueDuration.Location = [System.Drawing.Point]::new($labelValueDuration.Location.X + $labelValueDuration.Width, $labelValue.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxValueDuration)

    [System.Windows.Forms.Label]$labelValueEasing | Out-Null # Out-Null to avoid messages in the console
    $labelValueEasing = New-Object System.Windows.Forms.Label
    $labelValueEasing.AutoSize = $true
    $labelValueEasing.Text = "Easing:"
    $labelValueEasing.Location = [System.Drawing.Point]::new($Script:txtBoxValueDuration.Location.X + $Script:txtBoxValueDuration.Width + 20, $labelValue.Location.Y)
    $grBoxSettings.Controls.Add($labelValueEasing)

    $Script:cBoxValueEasing = New-Object System.Windows.Forms.ComboBox
    $Script:cBoxValueEasing.DropDownStyle = 'DropDownList'
    $Script:cBoxValueEasing.AutoSize = $true
    $Script:cBoxValueEasing.Location = [System.Drawing.Point]::new($labelValueEasing.Location.X + $labelValueEasing.Width, $labelValue.Location.Y - 2)
    PopulateComboBoxEasing $Script:cBoxValueEasing
    $Script:cBoxValueEasing.SelectedIndex = 0
    $grBoxSettings.Controls.Add($Script:cBoxValueEasing)

    [System.Windows.Forms.Label]$labelValueType | Out-Null # Out-Null to avoid messages in the console
    $labelValueType = New-Object System.Windows.Forms.Label
    $labelValueType.AutoSize = $true
    $labelValueType.Text = "type:"
    $labelValueType.Location = [System.Drawing.Point]::new($Script:cBoxValueEasing.Location.X + $Script:cBoxValueEasing.Width, $labelValue.Location.Y)
    $grBoxSettings.Controls.Add($labelValueType)

    $Script:cBoxValueType = New-Object System.Windows.Forms.ComboBox
    $Script:cBoxValueType.DropDownStyle = 'DropDownList'
    $Script:cBoxValueType.Width = 75
    $Script:cBoxValueType.Location = [System.Drawing.Point]::new($labelValueType.Location.X + $labelValueType.Width, $labelValue.Location.Y - 2)
    $Script:cBoxValueType.Items.AddRange(("int", "double"))
    $Script:cBoxValueType.SelectedIndex = 0
    $grBoxSettings.Controls.Add($Script:cBoxValueType)

    #endregion

    #region AnimatedProgressBar

    [System.Windows.Forms.Label]$labelProgressBar | Out-Null # Out-Null to avoid messages in the console
    $labelProgressBar = New-Object System.Windows.Forms.Label
    $labelProgressBar.AutoSize = $true
    $labelProgressBar.Text = "`"ProgressBar`":"
    $labelProgressBar.Location = [System.Drawing.Point]::new(5, $labelValue.Location.Y + $labelValue.Height + 10)
    $grBoxSettings.Controls.Add($labelProgressBar)

    [System.Windows.Forms.Label]$labelProgressBarStart | Out-Null # Out-Null to avoid messages in the console
    $labelProgressBarStart = New-Object System.Windows.Forms.Label
    $labelProgressBarStart.AutoSize = $true
    $labelProgressBarStart.Text = "from (%):"
    $labelProgressBarStart.Location = [System.Drawing.Point]::new(141, $labelProgressBar.Location.Y)
    $grBoxSettings.Controls.Add($labelProgressBarStart) 

    $Script:txtBoxProgressBarStart = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxProgressBarStart.Width = 25
    $Script:txtBoxProgressBarStart.Text = "0"
    $Script:txtBoxProgressBarStart.Location = [System.Drawing.Point]::new(194, $labelProgressBar.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxProgressBarStart)

    [System.Windows.Forms.Label]$labelProgressBarEnd | Out-Null # Out-Null to avoid messages in the console
    $labelProgressBarEnd = New-Object System.Windows.Forms.Label
    $labelProgressBarEnd.AutoSize = $true
    $labelProgressBarEnd.Text = "to:"
    $labelProgressBarEnd.Location = [System.Drawing.Point]::new($Script:txtBoxProgressBarStart.Location.X + $Script:txtBoxProgressBarStart.Width, $labelProgressBar.Location.Y)
    $grBoxSettings.Controls.Add($labelProgressBarEnd)

    $Script:txtBoxProgressBarEnd = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxProgressBarEnd.Width = 25
    $Script:txtBoxProgressBarEnd.Text = "100"
    $Script:txtBoxProgressBarEnd.Location = [System.Drawing.Point]::new($labelProgressBarEnd.Location.X + $labelProgressBarEnd.Width, $labelProgressBar.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxProgressBarEnd)

    [System.Windows.Forms.Label]$labelProgressBarDuration | Out-Null # Out-Null to avoid messages in the console
    $labelProgressBarDuration = New-Object System.Windows.Forms.Label
    $labelProgressBarDuration.AutoSize = $true
    $labelProgressBarDuration.Text = "duration (sec):"
    $labelProgressBarDuration.Location = [System.Drawing.Point]::new($Script:txtBoxProgressBarEnd.Location.X + $Script:txtBoxProgressBarEnd.Width + 20, $labelProgressBar.Location.Y)
    $grBoxSettings.Controls.Add($labelProgressBarDuration)

    $Script:txtBoxProgressBarDuration = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxProgressBarDuration.Width = 25
    $Script:txtBoxProgressBarDuration.Text = 5
    $Script:txtBoxProgressBarDuration.Location = [System.Drawing.Point]::new($labelProgressBarDuration.Location.X + $labelProgressBarDuration.Width, $labelProgressBar.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxProgressBarDuration)

    [System.Windows.Forms.Label]$labelProgressBarEasing | Out-Null # Out-Null to avoid messages in the console
    $labelProgressBarEasing = New-Object System.Windows.Forms.Label
    $labelProgressBarEasing.AutoSize = $true
    $labelProgressBarEasing.Text = "Easing:"
    $labelProgressBarEasing.Location = [System.Drawing.Point]::new($Script:txtBoxProgressBarDuration.Location.X + $Script:txtBoxProgressBarDuration.Width + 20, $labelProgressBar.Location.Y)
    $grBoxSettings.Controls.Add($labelProgressBarEasing)

    $Script:cBoxProgressBarEasing = New-Object System.Windows.Forms.ComboBox
    $Script:cBoxProgressBarEasing.DropDownStyle = 'DropDownList'
    $Script:cBoxProgressBarEasing.AutoSize = $true
    $Script:cBoxProgressBarEasing.Location = [System.Drawing.Point]::new($labelProgressBarEasing.Location.X + $labelProgressBarEasing.Width, $labelProgressBar.Location.Y - 2)
    PopulateComboBoxEasing $Script:cBoxProgressBarEasing
    $Script:cBoxProgressBarEasing.SelectedIndex = 0
    $grBoxSettings.Controls.Add($Script:cBoxProgressBarEasing)

    #endregion

    #region color

    [System.Windows.Forms.Label]$labelColor | Out-Null # Out-Null to avoid messages in the console
    $labelColor = New-Object System.Windows.Forms.Label
    $labelColor.AutoSize = $true
    $labelColor.Text = "`"Color transition`":"
    $labelColor.Location = [System.Drawing.Point]::new(5, $labelProgressBar.Location.Y + $labelProgressBar.Height + 10)
    $grBoxSettings.Controls.Add($labelColor)

    [System.Windows.Forms.Label]$labelColorFrom | Out-Null # Out-Null to avoid messages in the console
    $labelColorFrom = New-Object System.Windows.Forms.Label
    $labelColorFrom.AutoSize = $true
    $labelColorFrom.Text = "from:"
    $labelColorFrom.Location = [System.Drawing.Point]::new(162, $labelColor.Location.Y)
    $grBoxSettings.Controls.Add($labelColorFrom) 

    [System.Windows.Forms.Button]$btnColorStart | Out-Null # Out-Null to avoid messages in the console
    $btnColorStart = New-Object System.Windows.Forms.Button
    $btnColorStart.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnColorStart.Width = 23
    $btnColorStart.Height = 20
    $btnColorStart.BackColor = [System.Drawing.Color]::Black
    $btnColorStart.Name = "btnColorStart"
    $btnColorStart.Location = [System.Drawing.Point]::new($labelColorFrom.Location.X + $labelColorFrom.Width, $labelColor.Location.Y - 2)
    $btnColorStart.Add_Click({ onClickColorButton })
    $grBoxSettings.Controls.Add($btnColorStart)
    
    [System.Windows.Forms.Label]$labelColorTo | Out-Null # Out-Null to avoid messages in the console
    $labelColorTo = New-Object System.Windows.Forms.Label
    $labelColorTo.AutoSize = $true
    $labelColorTo.Text = "to:"
    $labelColorTo.Location = [System.Drawing.Point]::new($btnColorStart.Location.X + $btnColorStart.Width + 1, $labelColor.Location.Y)
    $grBoxSettings.Controls.Add($labelColorTo)

    [System.Windows.Forms.Button]$btnColorEnd | Out-Null # Out-Null to avoid messages in the console
    $btnColorEnd = New-Object System.Windows.Forms.Button
    $btnColorEnd.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnColorEnd.Width = 23
    $btnColorEnd.Height = 20
    $btnColorEnd.BackColor = [System.Drawing.Color]::White
    $btnColorEnd.Name = "btnColorEnd"
    $btnColorEnd.Location = [System.Drawing.Point]::new($labelColorTo.Location.X + $labelColorTo.Width, $labelColor.Location.Y - 2)
    $btnColorEnd.Add_Click({ onClickColorButton })
    $grBoxSettings.Controls.Add($btnColorEnd)

    [System.Windows.Forms.Label]$labelColorDuration | Out-Null # Out-Null to avoid messages in the console
    $labelColorDuration = New-Object System.Windows.Forms.Label
    $labelColorDuration.AutoSize = $true
    $labelColorDuration.Text = "duration (sec):"
    $labelColorDuration.Location = [System.Drawing.Point]::new($btnColorEnd.Location.X + $btnColorEnd.Width + 21, $labelColor.Location.Y)
    $grBoxSettings.Controls.Add($labelColorDuration)

    $Script:txtBoxColorDuration = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxColorDuration.Width = 25
    $Script:txtBoxColorDuration.Text = 5
    $Script:txtBoxColorDuration.Location = [System.Drawing.Point]::new($labelColorDuration.Location.X + $labelColorDuration.Width, $labelColor.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxColorDuration)

    [System.Windows.Forms.Label]$labelColorEasing | Out-Null # Out-Null to avoid messages in the console
    $labelColorEasing = New-Object System.Windows.Forms.Label
    $labelColorEasing.AutoSize = $true
    $labelColorEasing.Text = "Easing:"
    $labelColorEasing.Location = [System.Drawing.Point]::new($Script:txtBoxColorDuration.Location.X + $Script:txtBoxColorDuration.Width + 21, $labelColor.Location.Y)
    $grBoxSettings.Controls.Add($labelColorEasing)

    $Script:cBoxColorEasing = New-Object System.Windows.Forms.ComboBox
    $Script:cBoxColorEasing.DropDownStyle = 'DropDownList'
    $Script:cBoxColorEasing.AutoSize = $true
    $Script:cBoxColorEasing.Location = [System.Drawing.Point]::new($labelColorEasing.Location.X + $labelColorEasing.Width, $labelColor.Location.Y - 2)
    PopulateComboBoxEasing $Script:cBoxColorEasing
    $Script:cBoxColorEasing.SelectedIndex = 0
    $grBoxSettings.Controls.Add($Script:cBoxColorEasing)

    #endregion

    #region AnimatedButton
    
    [System.Windows.Forms.Label]$labelBtn1 | Out-Null # Out-Null to avoid messages in the console
    $labelBtn1 = New-Object System.Windows.Forms.Label
    $labelBtn1.AutoSize = $true
    $labelBtn1.Text = "`"Animated Button`":"
    $labelBtn1.Location = [System.Drawing.Point]::new(5, $labelColor.Location.Y + $labelColor.Height + 10)
    $grBoxSettings.Controls.Add($labelBtn1) 

    [System.Windows.Forms.Label]$labelBtn1Dest | Out-Null # Out-Null to avoid messages in the console
    $labelBtn1Dest = New-Object System.Windows.Forms.Label
    $labelBtn1Dest.AutoSize = $true
    $labelBtn1Dest.Text = "destination:"
    $labelBtn1Dest.Location = [System.Drawing.Point]::new(112, $labelBtn1.Location.Y)
    $grBoxSettings.Controls.Add($labelBtn1Dest)    

    [System.Windows.Forms.Label]$labelBtn1DestX | Out-Null # Out-Null to avoid messages in the console
    $labelBtn1DestX = New-Object System.Windows.Forms.Label
    $labelBtn1DestX.AutoSize = $true
    $labelBtn1DestX.Text = "X:"
    $labelBtn1DestX.Location = [System.Drawing.Point]::new($labelBtn1Dest.Location.x + $labelBtn1Dest.Width, $labelBtn1.Location.Y)
    $grBoxSettings.Controls.Add($labelBtn1DestX)

    $Script:txtBoxBtn1DestX = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxBtn1DestX.Width = 25
    $Script:txtBoxBtn1DestX.Text = $Script:animatedBtn.Location.X.ToString()
    $Script:txtBoxBtn1DestX.Location = [System.Drawing.Point]::new($labelBtn1DestX.Location.X + $labelBtn1DestX.Width, $labelBtn1.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxBtn1DestX)

    [System.Windows.Forms.Label]$labelBtn1DestY | Out-Null # Out-Null to avoid messages in the console
    $labelBtn1DestY = New-Object System.Windows.Forms.Label
    $labelBtn1DestY.AutoSize = $true
    $labelBtn1DestY.Text = "Y:"
    $labelBtn1DestY.Location = [System.Drawing.Point]::new($Script:txtBoxBtn1DestX.Location.X + $Script:txtBoxBtn1DestX.Width + 5, $labelBtn1.Location.Y)
    $grBoxSettings.Controls.Add($labelBtn1DestY)

    $Script:txtBoxBtn1DestY = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxBtn1DestY.Width = 25
    $Script:txtBoxBtn1DestY.Text = $Script:animatedBtn.Location.Y.ToString()
    $Script:txtBoxBtn1DestY.Location = [System.Drawing.Point]::new(238, $labelBtn1.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxBtn1DestY)

    [System.Windows.Forms.Label]$labelBtn1Duration | Out-Null # Out-Null to avoid messages in the console
    $labelBtn1Duration = New-Object System.Windows.Forms.Label
    $labelBtn1Duration.AutoSize = $true
    $labelBtn1Duration.Text = "duration (sec):"
    $labelBtn1Duration.Location = [System.Drawing.Point]::new($txtBoxBtn1DestY.Location.X + $txtBoxBtn1DestY.Width + 20, $labelBtn1.Location.Y)
    $grBoxSettings.Controls.Add($labelBtn1Duration)

    $Script:txtBoxBtn1Duration = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxBtn1Duration.Width = 25
    $Script:txtBoxBtn1Duration.Text = 5
    $Script:txtBoxBtn1Duration.Location = [System.Drawing.Point]::new($labelBtn1Duration.Location.X + $labelBtn1Duration.Width, $labelBtn1.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxBtn1Duration)

    [System.Windows.Forms.Label]$labelBtn1Easing | Out-Null # Out-Null to avoid messages in the console
    $labelBtn1Easing = New-Object System.Windows.Forms.Label
    $labelBtn1Easing.AutoSize = $true
    $labelBtn1Easing.Text = "Easing:"
    $labelBtn1Easing.Location = [System.Drawing.Point]::new($Script:txtBoxBtn1Duration.Location.X + $Script:txtBoxBtn1Duration.Width + 20, $labelBtn1.Location.Y)
    $grBoxSettings.Controls.Add($labelBtn1Easing)

    $Script:cBoxBtn1Easing = New-Object System.Windows.Forms.ComboBox
    $Script:cBoxBtn1Easing.DropDownStyle = 'DropDownList'
    $Script:cBoxBtn1Easing.AutoSize = $true
    $Script:cBoxBtn1Easing.Location = [System.Drawing.Point]::new($labelBtn1Easing.Location.X + $labelBtn1Easing.Width, $labelBtn1.Location.Y - 2)
    PopulateComboBoxEasing $Script:cBoxBtn1Easing
    $Script:cBoxBtn1Easing.SelectedIndex = 0
    $grBoxSettings.Controls.Add($Script:cBoxBtn1Easing)
    
    #endregion

    #region AnimatedLabel
    
    [System.Windows.Forms.Label]$labelLabel | Out-Null # Out-Null to avoid messages in the console
    $labelLabel = New-Object System.Windows.Forms.Label
    $labelLabel.AutoSize = $true
    $labelLabel.Text = "`"Animated Label`":"
    $labelLabel.Location = [System.Drawing.Point]::new(5, $labelBtn1.Location.Y + $labelBtn1.Height + 10)
    $grBoxSettings.Controls.Add($labelLabel)  

    [System.Windows.Forms.Label]$labelLabelDest | Out-Null # Out-Null to avoid messages in the console
    $labelLabelDest = New-Object System.Windows.Forms.Label
    $labelLabelDest.AutoSize = $true
    $labelLabelDest.Text = "destination:"
    $labelLabelDest.Location = [System.Drawing.Point]::new(112, $labelLabel.Location.Y)
    $grBoxSettings.Controls.Add($labelLabelDest)    

    [System.Windows.Forms.Label]$labelLabelDestX | Out-Null # Out-Null to avoid messages in the console
    $labelLabelDestX = New-Object System.Windows.Forms.Label
    $labelLabelDestX.AutoSize = $true
    $labelLabelDestX.Text = "X:"
    $labelLabelDestX.Location = [System.Drawing.Point]::new($labelLabelDest.Location.X + $labelLabelDest.Width, $labelLabel.Location.Y)
    $grBoxSettings.Controls.Add($labelLabelDestX)

    $Script:txtBoxLabelDestX = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxLabelDestX.Width = 25
    $Script:txtBoxLabelDestX.Text = $Script:animatedLabel.Location.X.ToString()
    $Script:txtBoxLabelDestX.Location = [System.Drawing.Point]::new($labelLabelDestX.Location.X + $labelLabelDestX.Width, $labelLabel.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxLabelDestX)

    [System.Windows.Forms.Label]$labelLabelDestY | Out-Null # Out-Null to avoid messages in the console
    $labelLabelDestY = New-Object System.Windows.Forms.Label
    $labelLabelDestY.AutoSize = $true
    $labelLabelDestY.Text = "Y:"
    $labelLabelDestY.Location = [System.Drawing.Point]::new($Script:txtBoxLabelDestX.Location.X + $Script:txtBoxLabelDestX.Width + 5, $labelLabel.Location.Y)
    $grBoxSettings.Controls.Add($labelLabelDestY)

    $Script:txtBoxLabelDestY = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxLabelDestY.Width = 25
    $Script:txtBoxLabelDestY.Text = $Script:animatedLabel.Location.Y.ToString()
    $Script:txtBoxLabelDestY.Location = [System.Drawing.Point]::new(238, $labelLabel.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxLabelDestY)

    [System.Windows.Forms.Label]$labelLabelDuration | Out-Null # Out-Null to avoid messages in the console
    $labelLabelDuration = New-Object System.Windows.Forms.Label
    $labelLabelDuration.AutoSize = $true
    $labelLabelDuration.Text = "duration (sec):"
    $labelLabelDuration.Location = [System.Drawing.Point]::new($txtBoxLabelDestY.Location.X + $txtBoxLabelDestY.Width + 20, $labelLabel.Location.Y)
    $grBoxSettings.Controls.Add($labelLabelDuration)

    $Script:txtBoxLabelDuration = New-Object System.Windows.Forms.TextBox
    $Script:txtBoxLabelDuration.Width = 25
    $Script:txtBoxLabelDuration.Text = 5
    $Script:txtBoxLabelDuration.Location = [System.Drawing.Point]::new($labelLabelDuration.Location.X + $labelLabelDuration.Width, $labelLabel.Location.Y - 2)
    $grBoxSettings.Controls.Add($Script:txtBoxLabelDuration)

    [System.Windows.Forms.Label]$labelLabelEasing | Out-Null # Out-Null to avoid messages in the console
    $labelLabelEasing = New-Object System.Windows.Forms.Label
    $labelLabelEasing.AutoSize = $true
    $labelLabelEasing.Text = "Easing:"
    $labelLabelEasing.Location = [System.Drawing.Point]::new($Script:txtBoxLabelDuration.Location.X + $Script:txtBoxLabelDuration.Width + 20, $labelLabel.Location.Y)
    $grBoxSettings.Controls.Add($labelLabelEasing)

    $Script:cBoxLabelEasing = New-Object System.Windows.Forms.ComboBox
    $Script:cBoxLabelEasing.DropDownStyle = 'DropDownList'
    $Script:cBoxLabelEasing.AutoSize = $true
    $Script:cBoxLabelEasing.Location = [System.Drawing.Point]::new($labelLabelEasing.Location.X + $labelLabelEasing.Width, $labelLabel.Location.Y - 2)
    PopulateComboBoxEasing $Script:cBoxLabelEasing
    $Script:cBoxLabelEasing.SelectedIndex = 0
    $grBoxSettings.Controls.Add($Script:cBoxLabelEasing)
    
    #endregion

    #region instructions

    [System.Windows.Forms.GroupBox]$grBoxInstructions
    $grBoxInstructions = New-Object System.Windows.Forms.GroupBox
    $grBoxInstructions.Margin = 0
    $grBoxInstructions.Location = [System.Drawing.Point]::new($Script:cBoxBtn1Easing.Location.X + $Script:cBoxBtn1Easing.Width + 5, $Script:cBoxBtn1Easing.Location.Y - 6)
    $grBoxInstructions.Width = $grBoxSettings.Width - $grBoxInstructions.Location.X - 5
    $grBoxInstructions.Height = $Script:cBoxLabelEasing.Location.Y + $Script:cBoxLabelEasing.Height - $Script:cBoxBtn1Easing.Location.Y + 7
    $grBoxSettings.Controls.Add($grBoxInstructions)

    [System.Windows.Forms.Label]$labelInstructions
    $labelInstructions = New-Object System.Windows.Forms.Label
    $labelInstructions.Width = $grBoxInstructions.Width - 10
    $labelInstructions.Height = $grBoxInstructions.Height - 10
    $labelInstructions.Location = [System.Drawing.Point]::new(5, 10)
    $labelInstructions.Text = "Try to stay in the approx. aera:`nTop Left [0, 120]`nBottom Right [600, 300]"
    $labelInstructions.BackColor = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
    $grBoxInstructions.Controls.Add($labelInstructions)

    #endregion

    # Manual adjsutement of the grBox Height
    $grBoxSettings.Height = $labelLabel.Location.Y + $labelLabel.Height + 10
    # Place the grBox after setting the Height according to content
    $grBoxSettings.Location = [System.Drawing.Point]::new(5, $Script:btnStart.Location.Y - $grBoxSettings.Height - 5)
}

function PopulateComboBoxEasing {
    <#
    .SYNOPSIS
        Fills a ComboBox with available easing functions.
    .DESCRIPTION
        Adds a predefined list of easing algorithm names (linear, bounce, elastic, etc.) to the provided ComboBox control.
    .PARAMETER cBox
        The Windows Forms ComboBox control to populate.
    .EXAMPLE
        PopulateComboBoxEasing $myComboBox
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.ComboBox]
        $cBox
    )

    $cBox.Items.AddRange((
            $easeLinear,
            $easeExpoOut, $easeExpoIn, $easeExpoInOut, $easeExpoOutIn,
            $easeCircOut, $easeCircIn, $easeCircInOut, $easeCircOutIn,
            $easeQuadOut, $easeQuadIn, $easeQuadInOut, $easeQuadOutIn,
            $easeSineOut, $easeSineIn, $easeSineInOut, $easeSineOutIn,
            $easeCubicOut, $easeCubicIn, $easeCubicInOut, $easeCubicOutIn,
            $easeQuartOut, $easeQuartIn, $easeQuartInOut, $easeQuartOutIn,
            $easeQuintOut, $easeQuintIn, $easeQuintInOut, $easeQuintOutIn,
            $easeElasticOut, $easeElasticIn, $easeElasticInOut, $easeElasticOutIn,
            $easeBounceOut, $easeBounceIn, $easeBounceInOut, $easeBounceOutIn,
            $easeBackOut, $easeBackIn, $easeBackInOut, $easeBackOutIn
        ))

}

function CreateBtnStart {
    <#
    .SYNOPSIS
        Creates the Start button.
    .DESCRIPTION
        Initializes and positions the button responsible for triggering the animation sequence.
    #>

    $Script:btnStart = New-Object System.Windows.Forms.Button
    $Script:btnStart.AutoSize = $true
    $Script:btnStart.Text = "Start"
    $Script:btnStart.Add_Click({ onClickBtnStart })

    $Script:btnStart.Location = [System.Drawing.Point]::new($($Script:mainForm.ClientSize.Width - $Script:btnStart.Width) / 2, $($Script:mainForm.ClientSize.Height - $Script:btnStart.Height - 10))
    
    $Script:mainForm.Controls.Add($Script:btnStart)
}

function CreateBtnReset {
    <#
    .SYNOPSIS
        Creates the Reset button.
    .DESCRIPTION
        Initializes and positions the button used to return the animated objects to their initial positions.
    #>

    $Script:btnReset = New-Object System.Windows.Forms.Button
    $Script:btnReset.AutoSize = $true
    $Script:btnReset.Text = "Reset"
    $Script:btnReset.Add_Click({ onClickBtnReset })
    
    $Script:btnReset.Location = [System.Drawing.Point]::new($($Script:mainForm.Width - $Script:btnReset.Width - 20), $($Script:mainForm.ClientSize.Height - $Script:btnReset.Height - 10))
   
    $Script:mainForm.Controls.Add($Script:btnReset)
}

#endregion

#region Controllers

function onClickBtnStart {
    <#
    .SYNOPSIS
        Event handler for the Start button click.
    .DESCRIPTION
        Reads configuration settings from the UI and creates Tween instances for numeric text, 
        progress bar progress, color transitions, and control movement.
    .NOTES
        This function acts as the primary orchestrator for the demo, populating the $Script:listToAnimate collection 
        with various Tween class instances defined in the library.
    #>

    $tweenValue = [TweenNumericString]::new($Script:animatedValue, $Script:cBoxValueType.SelectedItem, [double]$Script:txtBoxValueFrom.Text, [double]$Script:txtBoxValueTo.Text, [double]$Script:txtBoxValueDuration.Text, $Script:cBoxValueEasing.SelectedItem, { onCompleteAnimation })
    $Script:listToAnimate.Add($tweenValue)

    $tweenProgressBar = [TweenProgressBar]::new($Script:animatedProgressBar, [double]$Script:txtBoxProgressBarStart.Text, [double]$Script:txtBoxProgressBarEnd.Text, [double]$Script:txtBoxProgressBarDuration.Text, $Script:cBoxProgressBarEasing.SelectedItem, $null)
    $Script:listToAnimate.Add($tweenProgressBar)

    $tweenColorLabel = [TweenColorARGB]::new($Script:coloredLabel, "ForeColor", $Script:colorStart, $Script:colorEnd, $Script:txtBoxColorDuration.Text, $Script:cBoxColorEasing.SelectedItem, $null)
    $Script:listToAnimate.Add($tweenColorLabel)

    $tweenColorLabelBkg = [TweenColorARGB]::new($Script:coloredLabelBkg, "BackColor", $Script:colorStart, $Script:colorEnd, $Script:txtBoxColorDuration.Text, $Script:cBoxColorEasing.SelectedItem, $null)
    $Script:listToAnimate.Add($tweenColorLabelBkg)

    $destPos = [System.Drawing.Point]::new([int]$Script:txtBoxBtn1DestX.Text, [int]$Script:TxtBoxBtn1DestY.Text)
    $tweenBtn1 = [TweenMoveTo]::new($Script:animatedBtn, $destPos, [Double]$Script:txtBoxBtn1Duration.Text, $Script:cBoxBtn1Easing.SelectedItem, $null)
    $Script:listToAnimate.Add($tweenBtn1)

    $destPos = [System.Drawing.Point]::new([int]$Script:txtBoxLabelDestX.Text, [int]$Script:TxtBoxLabelDestY.Text)
    $tweenLabel = [TweenMoveTo]::new($Script:animatedLabel, $destPos, [Double]$Script:txtBoxLabelDuration.Text, $Script:cBoxLabelEasing.SelectedItem, $null)
    $Script:listToAnimate.Add($tweenLabel)

    $Script:animationStartTime = Get-Date
    # Write-Host "Animations starts at :" $Script:animationStartTime.ToString()

}

function onClickBtnReset {
    <#
    .SYNOPSIS
        Event handler for the Reset button click.
    .DESCRIPTION
        Resets the animated controls (button and label) to their initial UI coordinates.
    #>
    $Script:animatedBtn.Location = [System.Drawing.Point]::new(10, $coloredLabel.Location.Y + $coloredLabel.Height + 20)
    $Script:animatedLabel.Location = [System.Drawing.Point]::new(10, $animatedBtn.Location.Y + $animatedBtn.Height + 20)
}

function onClickColorButton {
    <#
    .SYNOPSIS
        Event handler for color selection buttons.
    .DESCRIPTION
        Displays a ColorDialog to allow selecting a color. The chosen color is 
        applied to the source button and stored as either the start or end color 
        for the upcoming color transition animation.
    #>

    $clickedBtn = $this

    [System.Windows.Forms.ColorDialog]$colorPicker
    $colorPicker = New-Object System.Windows.Forms.ColorDialog
    $colorPicker.AllowFullOpen = $true

    if ($colorPicker.ShowDialog() -eq 'OK') {

        $color = [System.Drawing.Color]::FromArgb(
            $colorPicker.Color.A,
            $colorPicker.Color.R,
            $colorPicker.Color.G,
            $colorPicker.Color.B
        )

        $clickedBtn.BackColor = $color
        
        if ($clickedBtn.Name -eq "btnColorStart") {
            $Script:colorStart = $color
        }
        else {
            $Script:colorEnd = $color
        }
    }
}

function onClickAnimatedButton {
    <#
    .SYNOPSIS
        Event handler for clicks on the animated button.
    .DESCRIPTION
        Writes a message to the host to demonstrate that the button remains interactive while moving.
    #>
    Write-Host "Click on an animated button"
}

function onCompleteAnimation {
    <#
    .SYNOPSIS
        Callback function executed when an animation completes.
    .DESCRIPTION
        This function is triggered by the tweening engine once an animation has finished its duration.
        It serves as a placeholder for executing subsequent logic or chaining animations.
    .EXAMPLE
        # Used as a callback in a Tween constructor:
        # [TweenNumericString]::new(..., { onCompleteAnimation })
    #>

    Write-Host "Animation completed. Now you can call another animation or whatever code you want"
}

#endregion

#region Main

# The main form where are displayed the objects
[System.Windows.Forms.Form]$Script:mainForm | Out-Null # Out-Null to avoid messages in the console

# The dynamic list of objets to animate :
[System.Collections.ArrayList]$Script:listToAnimate = @()

# TimeStamp of the beginning of the animation
# Just used to log the reel duration of the anmination
[System.DateTime]$Script:animationStartTime = Get-Date

# Animated objects :
[System.Windows.Forms.Label]$Script:animatedValue | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ProgressBar]$Script:animatedProgressBar | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.Label]$Script:coloredLabel | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.Label]$Script:coloredLabelBkg | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.Button]$Script:animatedBtn | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.Label]$Script:animatedLabel | Out-Null # Out-Null to avoid messages in the console

# Settings objects :
# Value
[System.Windows.Forms.TextBox]$Script:txtBoxValueFrom | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxValueTo | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ComboBox]$Script:cBoxValueType | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxValueDuration | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ComboBox]$Script:cBoxValueEasing | Out-Null # Out-Null to avoid messages in the console
# ProgressBar
[System.Windows.Forms.TextBox]$Script:txtBoxProgressBarStart | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxProgressBarEnd | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxProgressBarDuration | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ComboBox]$Script:cBoxProgressBarEasing | Out-Null # Out-Null to avoid messages in the console
# Color label
[System.Drawing.Color]$colorStart = [System.Drawing.Color]::Black
[System.Drawing.Color]$colorEnd = [System.Drawing.Color]::White
[System.Windows.Forms.TextBox]$Script:txtBoxColorDuration | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ComboBox]$Script:cBoxColorEasing | Out-Null # Out-Null to avoid messages in the console
# Button
[System.Windows.Forms.TextBox]$Script:txtBoxBtn1DestX | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxBtn1DestY | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxBtn1Duration | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ComboBox]$Script:cBoxBtn1Easing | Out-Null # Out-Null to avoid messages in the console
# Label
[System.Windows.Forms.TextBox]$Script:txtBoxLabelDestX | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxLabelDestY | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.TextBox]$Script:txtBoxLabelDuration | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.ComboBox]$Script:cBoxLabelEasing | Out-Null # Out-Null to avoid messages in the console
# Start/Reset buttons :
[System.Windows.Forms.Button]$Script:btnStart | Out-Null # Out-Null to avoid messages in the console
[System.Windows.Forms.Button]$Script:btnReset | Out-Null # Out-Null to avoid messages in the console

# Actions :
InitmainForm
CreateAnimatedControls
CreateBtnStart
CreateBtnReset
CreateInputs

# Lauching the main form : 
$Script:mainForm.Add_Shown({ $timer.Start() })
$Script:mainForm.Add_Closing({ 
    $timer.Stop()
    $timer.Dispose() 
})
$Script:mainForm.ShowDialog()

#endregion