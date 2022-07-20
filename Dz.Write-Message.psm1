# Region import everything we need
$culture = $host.CurrentCulture.Name -replace '-\w*$', ''
Import-LocalizedData  -UICulture $culture -BindingVariable Strings -FileName Strings -ErrorAction Ignore

If (-not $Strings) {
  Import-LocalizedData  -UICulture "en" -BindingVariable Strings -FileName Strings -ErrorAction Ignore
}

Try {
  [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
}Catch {
  Write-Warning -Message $Strings.SystemDrawingAvailable
}

Foreach ($Directory in @('Private', 'Public')) {
  Get-ChildItem -Path "$PSScriptRoot\$Directory\*.ps1" | ForEach-Object {. $_.FullName}
}

