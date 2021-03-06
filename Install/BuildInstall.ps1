﻿cd "$PSScriptRoot" 
& "$PSScriptRoot\CopyFiles.ps1"


& "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe" sign /v /n "West Wind Technologies" /sm /s MY /tr "http://timestamp.digicert.com" /td SHA256 /fd SHA256 ".\Distribution\MarkdownMonster.exe"
& "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe" sign /v /n "West Wind Technologies" /sm /s MY /tr "http://timestamp.digicert.com" /td SHA256 /fd SHA256 ".\Distribution\mm.exe"

# Installmate setup
#& "C:\Program Files\InstallMate 9\BinX64\tin.exe" /build:all "West Wind Markdown Monster.im9" | Out-null

"Running Inno Setup..."
& "C:\Program Files (x86)\Inno Setup 5\iscc.exe" "MarkdownMonster.iss" 

& "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe" sign /v /n "West Wind Technologies" /sm  /tr "http://timestamp.digicert.com" /td SHA256 /fd SHA256 ".\Builds\CurrentRelease\MarkdownMonsterSetup.exe"

copy ".\MarkdownMonsterPortable.md" ".\Distribution"

"Zipping up setup file..."
del ".\Builds\CurrentRelease\MarkdownMonsterSetup.zip"
7z a -tzip ".\Builds\CurrentRelease\MarkdownMonsterSetup.zip" ".\Builds\CurrentRelease\MarkdownMonsterSetup.exe"

"Zipping up portable setup file..."
del ".\Builds\CurrentRelease\MarkdownMonsterPortable.zip"
7z a -tzip -r ".\Builds\CurrentRelease\MarkdownMonsterPortable.zip" ".\Distribution\*.*"
7z a -tzip ".\Builds\CurrentRelease\MarkdownMonsterPortable.zip" ".\MarkdownMonsterPortable.md"

"Done!"

dir .\Builds\CurrentRelease


get-childitem .\builds\CurrentRelease\* -include *.* | foreach-object { "{0}`t{1}`t{2:n0}`t`t{3}" -f $_.Name, $_.LastWriteTime, $_.Length, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }