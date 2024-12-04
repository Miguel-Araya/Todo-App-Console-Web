
$DestinyFile = ".\FILE_OPTION.txt"

#The extension admitted to read
$ValidExtension = @("txt")

#The files that are exceptions and not be read
$FileException = @("TEMP.txt", "FILE_OPTION.txt", "TEMP_FILE.txt");

function Get-FileException($FileName){

   #if is true, is an exception
      
   if(-not $ValidExtension.Contains($FileName.split(".")[1])){

      return $true

   }
      
   return $FileException.Contains($FileName)
}

(type nul > $DestinyFile ) 2>$null

dir | sort | foreach{if(-not(Get-FileException($_.Name))){$_.Name | Out-File -FilePath $DestinyFile -Append -Encoding UTF8}}