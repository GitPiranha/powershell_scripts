##########################################################################
# File to split a large csv file into smaller ones
# The split files are stored in a subfolder
# parameters
#    LineLimit: specify the number of rows to keep in every line after the first row with the column names
##########################################################################

$InputFilename = Get-Content 'C:\powershell\scripts\test_data.csv'
$OutputFilenamePattern = 'output-filename_'

# Define variable to specify where splitted files are stored
$outputDirectory = "splitfiles"


# create the output directory if it does not exist
if (!(Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}


# Define how many lines to keep in every file after the first line which contains the column names
$LineLimit = 10

$line = 1
$i = 0
$file = 0
$start = 1


while ($line -le $InputFilename.Length) 
{
    # The if condition is not executed the first times
    # $i and $line are not equal to $LineLimit or $InputFilename.Length
    # So if statement is skipped and $i and $line are incremented until test is successful
    if ($i -eq $LineLimit -Or $line -eq $InputFilename.Length) 
    {
        # Inrease the file counter by 1
        $file++

        # Create the filename of the file with the reduced information
        $Filename = "$OutputFilenamePattern$file.csv"

        # Create a combination out of outputDirectory and the filename
        $outputFile = Join-Path $outputDirectory $Filename

        # Use first line in raw data always in first row
        $InputFilename[0] | Out-File -FilePath $outputFile -Force

        #$InputFilename[$start..($line-1)] | Out-File $Filename -Force # Use this line only if you do not need the header in every file

        # Append the other lines writing the first line
        $InputFilename[$start..($line-1)] | Out-File -FilePath $outputFile -Append
        
        # Here we set the rownumber from which to read in the next data
        $start = $line;

        # Here we reset the counter to zero so we can increment later again until the test in the if condition is true 
        $i = 0
        Write-Host "$outputFile"
    }
$i++;
$line++
}

