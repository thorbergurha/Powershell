[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


#begin to draw forms
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Computer Pinging Tool"
$Form.Size = New-Object System.Drawing.Size(330,150)
$Form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Size(5,5)
$label.Size = New-Object System.Drawing.Size(240,30)
$label.Text = "Type any computer name to test if it is on the network and can respond to ping"
$Form.Controls.Add($label)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Size(5,40)
$textbox.Size = New-Object System.Drawing.Size(120,20)
#$textbox.Text = "Select source PC:"
$Form.Controls.Add($textbox)

$statusBar1 = New-Object System.Windows.Forms.StatusBar
$statusBar1.Name = "statusBar1"
$statusBar1.Text = "Ready..."
$form.Controls.Add($statusBar1)


$ping_computer_click =
    {
    $statusBar1.Text = “Testing…”
    $ComputerName = $textbox.Text

    if (Test-Connection $ComputerName -quiet -Count 2){
        Write-Host -ForegroundColor Green "Computer $ComputerName has network connection"
        $result_label.ForeColor= "Green"
        $result_label.Text = "System Successfully Pinged"
    }
    Else{
        Write-Host -ForegroundColor Red "Computer $ComputerName does not have network connection"
        $result_label.ForeColor= "Red"
        $result_label.Text = "System is NOT Pingable"
    }
     $statusBar1.Text = “Testing Complete”
    }

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(140,38)
$OKButton.Size = New-Object System.Drawing.Size(95,23)
$OKButton.Text = "Test connection"
$OKButton.Add_Click($ping_computer_click)
$Form.Controls.Add($OKButton)

$result_label = New-Object System.Windows.Forms.label
$result_label.Location = New-Object System.Drawing.Size(5,65)
$result_label.Size = New-Object System.Drawing.Size(240,30)
$result_label.Text = "Results will be listed here"
$Form.Controls.Add($result_label)

#end draw forms

$Form.KeyPreview = $True
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape")
{$Form.Close()}})

#Show form
$Form.Topmost = $True
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()