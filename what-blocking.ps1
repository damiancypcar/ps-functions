[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs')] Param()

function what-blocking {
    # Check what process is using the given file/folder
    Param (
    [string]$file = "",
    [switch]$help = $false
    )

    function show_help {
        Write-Host "Displays information about open handles for any process in the system"
        Write-Host ("`nUsage:  {0} [options] <file/directory>`n" -f (Get-PSCallStack)[1].Command)
        Write-Host "options:`n-help`tshow help"
        break
    }

    function command_check {
        $cmdName = 'handle'
        $toolLink = 'https://docs.microsoft.com/en-us/sysinternals/downloads/handle'
        if (-not (Get-Command $cmdName -errorAction SilentlyContinue) -or (Get-Command $cmdName"64" -errorAction SilentlyContinue))
        {
            Write-Host "$cmdName doesn't exists in system`n"
            Write-Host "Visit $toolLink for more information"
            break
        }
    }

    function main {
        if (-Not $file) {
            $path = (Get-Location).Path
        }
        elseif (Test-Path $file) {
            $path = (Resolve-Path -Path $file).Path.Trim('\')
        }
        else {
            Write-Host "Can't find the path"
            break
        }
        handle.exe -nobanner $path
    }

    # print help message on -help switch
    if ($help) {
        show_help
    }else {
        command_check
        main
    }
}
