<#
.SYNOPSIS
    Deploys ARM template at subscription level
.EXAMPLE
    PS C:\> logprofiles.deploy.ps1 -Location "West Europe"
    Deploys logprofiles.json template with parameters from logprofiles.parameters.json file
.NOTES
    Script assumes convention over configuration approach.
    If all files will be named correctly e.g.
    
    logprofiles.json
    logprofiles.parameters.json
    logprofiles.deploy.ps1

    script will disassemble file names and process only the ones with proper name.
#>
[CmdletBinding()]
param (
    $Location
)

begin {
    $TemplateName = $MyInvocation.MyCommand.Name.Split('.')[0]
    $TemplateFile = Get-Item -Path "$PSScriptRoot\$TemplateName.json"
    $TemplateParameterFile = Get-Item -Path "$PSScriptRoot\$TemplateName.parameters.json" -ErrorAction SilentlyContinue
}

process {
    $DeploymentParameters = @{
        Name                  = ('deployment' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm'))
        Location              = $Location
        TemplateFile          = $TemplateFile
        Verbose               = $true
    }

    if ($TemplateParameterFile) {
        $DeploymentParameters.Add('TemplateParameterFile', $TemplateParameterFile)
    }

    New-AzDeployment @DeploymentParameters
}