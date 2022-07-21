![Write-Message](https://github.com/DecimalZero/Dz.Write-Message/tree/main/Images/Write-Message.png?raw=true)

<pre>
Write-Message is a wrapper around Write-Host allowing to display multiple colors of text on one line, and
will write the same message to an audit log file. Additional formatting includes line message indentation,
adding a blank line before the message, and adding a blank line after the message.
  
Data  
  | The message to be passed into the function.  
  | EXAMPLE: Write-Message 'Warning: The number of customers exceeded the maximum number of 39!!' 'Yellow'  
  |  
  | Alternatively, Double Quotes can be utilized to add variables.  
  | EXAMPLE: Write-Message "Warning: The number of customers exceeded the maximum number of $MaxNumber!!" 'Yellow'  
  |  
Color  
  | Font Colors: All font colors supported by PowerShell.  
  | | Black, Blue, Cyan, DarkBlue, DarkCyan, DarkGray, DarkGreen, DarkMagenta  
  | | DarkRed, DarkYellow, Gray, Green, Magenta, Red, White, & Yellow  
  | |  
  | Single Font Color:  
  | | If No font color is specified, font color White will be used.  
  | | EXAMPLE: Write-Message 'Warning: The number of customers exceeded the maximum number of 39!!'  
  | |   
  | | Alternatively, no quotes are required when defining the color.  
  | | EXMAPLE: Write-Message 'Warning: The number of customers exceeded the maximum number of 39!!' Red  
  | |  
  | Multiple Font Colors on Same Line:  
  | | Must seperate by "|" without quotes and must have the exact number of "|" as in the message.  
  | | EXAMPLE: Write-Message 'Warning: |The number of customers exceeded the maximum number of |39|!!' 'Red|White|Yellow|White'  
  | |  
  |  
-Indent1  
  | Add line indentation before the message.  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' -Indent1  
  |  
-Indent2  
  | Add line indentation before the message  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' -Indent2  
  |  
-AddLineBefore  
  | Adds a line before the message.  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' -AddLineBefore  
  |  
-AddLineAfter  
  | Adds a line after the message.  
  | EXAMPLE: Write-Message 'Hello World' 'Yellow' -AddLineAfter  
  |  

Example:
Write-Message 'Warning: |The number of customers exceeded the maximum number of |39|!!' 'Red|Cyan|Yellow|Cyan' -Indent2 -AddLineBefore -AddLineAfter

Audit Logs:
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
</pre>
