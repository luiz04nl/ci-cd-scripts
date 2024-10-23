$webConfigPath = "src/Web.config"
[xml]$webConfig = Get-Content $webConfigPath

$env:configVar_Environment = "FromEnv"

function Replace-AppSettings-WithEnvVars {
    foreach ($appSetting in $webConfig.configuration.appSettings.add) {
        $key = $appSetting.key
        $envVar = "configVar_$key"
        $envValue = [System.Environment]::GetEnvironmentVariable($envVar)

        if ($envValue) {
            Write-Host "Substituindo valor de AppSetting: $key com valor de variável de ambiente $envVar"
            $appSetting.value = $envValue
        }
    }
}

function Replace-ConnectionStrings-WithEnvVars {
    foreach ($connectionString in $webConfig.configuration.connectionStrings.add) {
        $name = $connectionString.name
        $envVar = "configVar_$name"
        $envValue = [System.Environment]::GetEnvironmentVariable($envVar)

        if ($envValue) {
            Write-Host "Substituindo valor de ConnectionString: $name com valor de variável de ambiente $envVar"
            $connectionString.connectionString = $envValue
        }
    }
}

Replace-AppSettings-WithEnvVars
Replace-ConnectionStrings-WithEnvVars

$webConfig.Save($webConfigPath)

Write-Host "Substituições baseadas em variáveis de ambiente concluídas com sucesso no Web.config"