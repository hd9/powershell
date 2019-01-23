function global:AvoidExp(){

    $netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])
    if($netAssembly)
    {
        $bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
        $settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")

        $instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())

        if($instance)
        {
            $bindingFlags = "NonPublic","Instance"
            $useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)

            if($useUnsafeHeaderParsingField)
            {
            $useUnsafeHeaderParsingField.SetValue($instance, $true)
            }
        }
    }
}


# support TLS
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'

cls

$filename = "urls.txt"
$outfile = "out.txt"

if (-not (Test-Path $filename))
{
    Write-Host "Please, provide a 'urls.txt' file`n`n"
    Return
}

Write-Host "Importing $filename ..."
$file = get-content $filename


# empties the output file
"" | out-file $outfile

$file | Foreach-Object {
    AvoidExp
    $url = $_
    if ($url.StartsWith("http")){

        "`n--------------------------" | out-file -append $outfile
        $url | out-file -append $outfile
        "--------------------------" | out-file -append $outfile

        try{
            Write-Host "Accessing $url" -NoNewLine
            $req = invoke-webrequest -uri $url
            $images = $req.Images.src

            Write-Host "[OK]"

            #Write-Host $links
            $images | out-file -append $outfile
        }
        catch{
           Write-Host "[ERROR] $error[0] ..."
        }

    }
}




