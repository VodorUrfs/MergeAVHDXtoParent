Clear-Host

# Written by Steve Williams, Infotect Design Solutions, 2-11-2019
# Customized and tidied by Gareth Morton, 05/08/2019
#
# Set the folder to search for newest file
# FolderPath is the location of the main VHDX and AVHDX files
$FolderPath = "PATH TO FILES HERE"
# ActiveVM is the first few letters of the VHDX name INCLUDING UNDERSCORE
$ActiveVM = "ESS-RDS01_"
$LoopCtr = 0
# PrefixLen is the length of ActiveVM variable (character length INCLUDING UNDERSCORE)
$PrefixLen = 10

# use Get-ChildItem to search folder. Note the Sort and Select
$currfile1 = gci -Path $FolderPath -File | Sort-Object -Property LastWriteTime -Descending | Select Name -First 1 

# Write to screen       
$currfile1.Name
$gofile = $currfile1.Name
    if($currfile1.Name.Substring(0,$PrefixLen) -match $ActiveVM) {

        Do {
            write-host "Running disk merge..."
            Write-host ""
            write-host "Attempting merge on" $gofile
            Write-host ""
            gci -path $FolderPath -File | Sort-Object -Property LastWriteTime -Descending | Select FullName, LastWriteTime -First 1
            # CHANGE THE PATH BELOW TO YOUR VM PATH
            Merge-VHD -Path "$FolderPath\$gofile" -Force
            Write-Host "Pausing for 20 seconds..."; start-sleep (20); Write-Host "Resuming..."
            $currfile1 = gci -Path $FolderPath -File | Sort-Object -Property LastWriteTime -Descending | Select Name -First 1
            $gofile = $currfile1.Name
            $LoopCtr++
            write-host "Loops Completed:" $LoopCtr 
        } while($currfile1.Name.Substring(0,$PrefixLen) -match $ActiveVM)
    } else {
        write-host "Stop running the script, the latest drive file is not matching."
    }
    write-host "DONE!"