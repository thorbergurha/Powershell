#Your XAML goes here :)
$inputXML = @"
<Window x:Class="PSapp.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:PSapp"
        mc:Ignorable="d" Height="248.994" Width="348.189" Title="PSapp">
    <Grid Margin="0,0,2,2">
        <Image HorizontalAlignment="Left" Height="79" Margin="24,24,0,0" VerticalAlignment="Top" Width="77" Source="C:\Users\Þorbergur Haraldsson\Pictures\PowerShell-logo.png"/>
        <TextBlock HorizontalAlignment="Left" Margin="106,24,0,0" TextWrapping="Wrap" Text="Use this tool to find out all sorts of useful disk information, and also to get rich input from your scripts and tools " VerticalAlignment="Top" Width="216" Height="79"/>
        <Button x:Name="OkButton" Content="OK" HorizontalAlignment="Left" Margin="247,152,0,0" VerticalAlignment="Top" Width="53" Height="27"/>
        <TextBox x:Name="CompName" HorizontalAlignment="Left" Height="23" Margin="132,116,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>

    </Grid>
</Window>

"@ 
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================
                                                                    
     
#Reference 
 
#Adding items to a dropdown/combo box
    #$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
     
#Setting the text of a text box to the current PC name    
    $WPFtextBox.Text = $env:COMPUTERNAME
     
#Adding code to a button, so that when clicked, it pings a system

$WPFbutton.Add_Click({ Test-connection -count 1 -ComputerName $WPFtextBox.Text
 })
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
'$Form.ShowDialog() | out-null'