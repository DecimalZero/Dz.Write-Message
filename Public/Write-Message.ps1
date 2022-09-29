<#PSScriptInfo

.NAME Write-Message

.VERSION 1.0.9

.DESCRIPTION 
 Write-Message is a wrapper around Write-Host allowing to display multiple colors of
 text on one line, and will write the same message to an audit log file. Additional
 formatting includes line message indentation, adding a blank line before the message,
 and adding a blank line after the message.

.GUID 9e8dfd44-f782-445a-883c-70614f71519c

.AUTHOR DecimalZero

.COMPANYNAME NestLink

.COPYRIGHT Copyright (C) DecimalZero.  All rights reserved.

.TAGS Write-Message Write-Host Color PowerShell Console Audit Logs Logging Windows Linux MacOS

.LICENSEURI
https://github.com/DecimalZero/Dz-Write-Message/blob/main/LICENSE

.PROJECTURI
https://github.com/DecimalZero/Dz-Write-Message

.ICONURI
https://github.com/DecimalZero/Dz-Write-Message/blob/main/Write-Message.png

.RELEASENOTES
https://github.com/DecimalZero/Dz-Write-Message/blob/main/README.md

.REQUIRESMODULE N/A

.EXTERNALMODULEDEPENDENCIES N/A 

.REQUIREDSCRIPTS N/A

.EXTERNALSCRIPTDEPENDENCIES N/A

.PRIVATEDATA N/A

.PARAMETERS   
Data
  | Write-Message {Message} {Foreground Color} {Background Color} {[-Indent1] [-Indent2] [-AddLineBefore] [-AddLineAfter]}
  |
  | The message to be passed into the function.  
  | EXAMPLE: Write-Message 'Warning: The number of customers exceeded the maximum number of 39!!' 'Yellow' 'Black' -Indent2 -AddLineBefore -AddLineAfter
  |
  | Alternatively, Double Quotes can be utilized to add variables.  
  | EXAMPLE: Write-Message "Warning: The number of customers exceeded the maximum number of $MaxNumber!!" 'Yellow' 'Black'
  |
Color
  | |
  | Foreground Font Colors: All font colors supported by PowerShell.  
  | | Black, Blue, Cyan, DarkBlue, DarkCyan, DarkGray, DarkGreen, DarkMagenta,  
  | | DarkRed, DarkYellow, Gray, Green, Magenta, Red, White, & Yellow
  | |
  | Background Font Colors: All font colors supported by PowerShell.  
  | | Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow,
  | | Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, & White  
  | |
  | Multiple Foreground Font Colors on Same Line:
  | | Must seperate by "|" without quotes and must have the exact number of "|" as in the message.  
  | | EXAMPLE: Write-Message 'Warning: |The number of customers exceeded the maximum number of |39|!!' 'Red|White|Yellow|White' 'Black'
  | |
  | | No quotes are required when defining the color.  
  | | EXMAPLE: Write-Message 'Warning: The number of customers exceeded the maximum number of 39!!' Red Black
  | |
  |
-Indent1  
  | Add line indentation before the message.  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' 'Black' -Indent1  
  |
-Indent2  
  | Add line indentation before the message  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' 'Black' -Indent2  
  |
-AddLineBefore  
  | Adds a line before the message.  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' 'Black' -AddLineBefore  
  |
-AddLineAfter  
  | Adds a line after the message.  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' 'Black' -AddLineAfter  
  |

.EXAMPLE
Write-Message 'Warning: |The number of customers exceeded the maximum number of |39|!!' 'Red|Cyan|Yellow|Cyan' 'Black' -Indent2 -AddLineBefore -AddLineAfter

.AUDITLOGS
If the $Global:AuditLogPathFile variable is missing, no logs will be written.  
The following example would be placed before this function.  
  
# Set audit folder name variables  
$AuditFolderName = 'AuditLogs'  
  
# Set global audit log path file  
$Global:AuditLogPathFile = (($PSScriptRoot) + ("\$AuditFolderName\") + ($(get-date -f yyyy-MM-dd-HH-mm-ss)) + ('-SomeFileName.log'))  
  
# Check if audit folder exists, if not create it  
If(-Not(Test-Path -LiteralPath (($PSScriptRoot) + ("\$AuditFolderName")))){  
  New-Item -Path $PSScriptRoot -Name $AuditFolderName -ItemType "Directory" | Out-Null  
}

#>

Function Write-Message{# Function to write message to host and audit log
  Param (
    [String]$Data,
    [String]$ForegroundColor = 'White',
    [String]$BackgroundColor = 'Black',
    [Switch]$Indent1,
    [Switch]$Indent2,
    [Switch]$AddLineAfter,
    [Switch]$AddLineBefore
  )
  # Set indent line
  If($Indent1){
    $IndentMessage = ' - '
  }Else {
    If($Indent2){
      $IndentMessage = '   '
    }Else {
      $IndentMessage = $Null
    }
  }
  # Set add line before
  If($AddLineBefore){
    $AddLineBreak = "`n"
  }Else {
    $AddLineBreak = $Null
  }
  # Process multicolor host message 
  If($ForegroundColor.Contains('|')){
    # Split color array
    $DataColor = $ForegroundColor.Split('|')
    # Split data array
    $DataMember = $Data.Split('|')
    # Loop through each data member in array
    For ($x = 0; $x -lt $DataMember.Count; $x++){
      Switch ($x){
        # Beginning of string
        {$x -eq 0} {
          # Write the data to the host the nonewline switch
          Write-Host (($AddLineBreak) + ($IndentMessage) + ($DataMember[$x])) -NoNewline -ForegroundColor $DataColor[$x]

          # Add first data pass to message variable
          $MassageData = $IndentMessage + $DataMember[$x]
        }
        # End of string
        {$DataMember.Count -eq $x+1}{
          # Check for the addline switch
          If($AddLineAfter){
            # Write the data to the host and include a new line space afterwards
            Write-Host $DataMember[$x] -ForegroundColor $DataColor[$x]; Write-Host
          }Else {
            # Check for the nonewline switch
            If($NoNewLine){
              # Write the data to the host and include a new line space afterwards
              Write-Host $DataMember[$x] -ForegroundColor $DataColor[$x] -NoNewline
            }Else {
              # Write the data to the host
              Write-Host $DataMember[$x] -ForegroundColor $DataColor[$x]
            }
          }
          # Add first data pass to message data variable
          $MassageData = $MassageData + $DataMember[$x]
        }
        # Middle of string
        Default {
          # Write the data to the host
          Write-Host $DataMember[$x] -ForegroundColor $DataColor[$x] -NoNewline 
            
          # Add data pass to message data variable
          $MassageData = $MassageData + $DataMember[$x]
        }
      }
    }
  }Else {# Process single host message
    # Check if add line before flag exists
    If($AddLineBefore){
      Write-Host
    }
    # Check if new line flag exists
    If($AddLineAfter){
      Write-Host ($IndentMessage + $Data) -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor; Write-Host
    }Else {
      Write-Host ($IndentMessage + $Data) -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
      
    # Add data to message variable
    $MassageData = $IndentMessage + $Data
  }
  # Save message to audit log
  If ($Global:AuditLogPathFile){
    If($AddLineBreak){
      Add-Content ((get-date -f yyyy-MM-dd-HH-mm-ss) + (':')) -Path $Global:AuditLogPathFile
    }
    If($AddLineAfter){
      Add-Content ((get-date -f yyyy-MM-dd-HH-mm-ss) + (': ') + ($MassageData)) -Path $Global:AuditLogPathFile
      Add-Content ((get-date -f yyyy-MM-dd-HH-mm-ss) + (':')) -Path $Global:AuditLogPathFile
    }Else {
      Add-Content ((get-date -f yyyy-MM-dd-HH-mm-ss) + (': ') + ($MassageData)) -Path $Global:AuditLogPathFile
    }
  }
}
