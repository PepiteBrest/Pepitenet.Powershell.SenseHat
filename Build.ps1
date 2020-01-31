param($action)

Write-Host ""
Write-Host "+-------------------------------+" -ForegroundColor Cyan
Write-Host "| Pepitenet.Powershell.SenseHat |" -ForegroundColor Cyan
Write-Host "+-------------------------------+" -ForegroundColor Cyan
Write-Host ""

function doBuildProject($loc)
{

    # Generates Pepitenet.Powershell.IoT
    Push-Location $location\src
    Write-Host "Generating Pepitenet.Powershell.SenseHat project" -ForegroundColor Cyan
    & dotnet build -c Release -o $OutputFolder | Out-Null
    Pop-Location
    
    Write-Host "Remove unnecessary files" -ForegroundColor Cyan
    Write-Host "Remove pdb files" -ForegroundColor DarkCyan
    Get-ChildItem -Path $OutputFolder -Filter "*.pdb" | Remove-Item
    Write-Host "Remove json files" -ForegroundColor DarkCyan
    Get-ChildItem -Path $OutputFolder -Filter "*.json" | Remove-Item
    Write-Host "Remove xml files" -ForegroundColor DarkCyan
    Get-ChildItem -Path $OutputFolder -Filter "*.xml" | Remove-Item

}

function doBuild($loc)
{
    # Generates dependencies
    Write-Host "Generating Dependencies" -ForegroundColor Cyan
    Push-Location "$location\submodule\SenseHat\Sense"
    Write-Host "Generating SenseHat project" -ForegroundColor DarkCyan
    & dotnet build -c Release -o $OutputFolder -f netstandard2.0 | Out-Null
    Pop-Location

    doBuildProject $loc
}

function doClean($loc)
{
    # Generates dependencies
    Write-Host "Cleaning Dependencies" -ForegroundColor Cyan
    Push-Location "$location\submodule\SenseHat\Sense"
    Write-Host "Cleaning SenseHat project" -ForegroundColor DarkCyan
    & dotnet clean -c Release -o $OutputFolder -f netstandard2.0 | Out-Null
    Pop-Location

    # Generates Pepitenet.Powershell.IoT
    Push-Location $location\src
    Write-Host "Cleaning Pepitenet.Powershell.SenseHat project" -ForegroundColor Cyan
    & dotnet clean -c Release -o $OutputFolder | Out-Null
    Pop-Location
}

$location = Get-Location
$OutputFolder = "$location\Output"

switch($action)
{
    "buildall" {
        # Init submodules
        git submodule update --init
        Write-Host "**** GENERATING PROJECT ****" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Creating Output Folder" -ForegroundColor Cyan
        if(Test-Path $OutputFolder)
        {
            Remove-Item -Path $OutputFolder -Recurse -Force
        }
        New-Item -ItemType Directory -Path $OutputFolder | Out-Null

        doBuild $location
        
        Copy-Item .\Pepitenet.Powershell.SenseHat.psd1 $OutputFolder

    }
    "build" {
        Write-Host "**** GENERATING PROJECT ****" -ForegroundColor Cyan
        Write-Host ""
        if(-Not (Test-Path $OutputFolder))
        {
            Write-Host "Creating Output Folder" -ForegroundColor Cyan
            New-Item -ItemType Directory -Path $OutputFolder | Out-Null
        }

        doBuildProject $location
        
        Copy-Item .\Pepitenet.Powershell.SenseHat.psd1 $OutputFolder

    }
    "clean" {
        Write-Host "**** CLEANING PROJECT ****" -ForegroundColor Cyan
        Write-Host ""
        doClean $location

        if(Test-Path $OutputFolder)
        {
            Write-Host "Removing Output folder content" -ForegroundColor Cyan
            Get-ChildItem -Path $OutputFolder | Remove-Item
        }
    }
    default {
        Write-Host "Please select of of these options :" -ForegroundColor Cyan
        Write-Host "- 'build' : Only build Pepitenet.Powershell.SenseHat" -ForegroundColor Cyan
        Write-Host "- 'buildall' : Build Pepitenet.Powershell.SenseHat and all its dependencies" -ForegroundColor Cyan
        Write-Host "- 'clean'" -ForegroundColor Cyan
    }
}
Write-Host ""
