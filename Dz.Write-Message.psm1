# Get the path to the function files
$PublicPath = $PSScriptRoot + "\Public\"

# Get list of all function filenames
$FunctionList = Get-ChildItem -Path $PublicPath -Include *.ps1 -Name

# Loop through all discovered files and dot-source them into memory
ForEach ( $Function in $FunctionList ) {
  . ( $PublicPath + $Function )
}