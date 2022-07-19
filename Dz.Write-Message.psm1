# Get all scripts
$Scripts = @(Get-ChildItem -Path $PSScriptRoot\Scripts\*.ps1 -ErrorAction SilentlyContinue -Recurse)

# Import all powershell files
Foreach ($Script in @(Scripts)) {
  Try {
    . $Script.Fullname
  }Catch {
    Write-Error -Message "Failed to Import Function $($Script.Fullname): $_"
  }
}

# Export module member function
Export-ModuleMember -Function 'Write-Message'

# Get powershell manifest file path
[String] $ManifestFile = '{0}.psd1' -f (Get-Item $PSCommandPath).BaseName;
$ManifestFilePath = Join-Path -Path $PSScriptRoot -ChildPath $ManifestFile;

# Test powershell manifest file path  
If (Test-Path -Path $ManifestFilePath) {
  # Check powershell manifest to powershell modules to remove
  $Manifest = (Get-Content -Raw $ManifestFilePath) | Invoke-Expression;
  Foreach ($ScriptToProcess in $Manifest.ScriptsToProcess) {
    $ModuleToRemove = (Get-Item (Join-Path -Path $PSScriptRoot -ChildPath $ScriptToProcess)).BaseName;
    If (Get-Module $ModuleToRemove) {
      Remove-Module $ModuleToRemove;
    }
  }
}
