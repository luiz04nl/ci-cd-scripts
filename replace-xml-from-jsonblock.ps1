$webConfigPath = "src/Web.config"
[xml]$webConfig = Get-Content $webConfigPath

$env:configVarBlock = @"
{
  "Environment": "FromConfigVarBlock",
  "DefaultConnection": "Server=myserver;Database=mytestdb;User Id=testuser;Password=testpassword;"
}
"@

$configVarBlock = [System.Environment]::GetEnvironmentVariable("configVarBlock")
$configVars = $configVarBlock | ConvertFrom-Json

function Replace-AppSettings-WithConfigVars {
    foreach ($appSetting in $webConfig.configuration.appSettings.add) {
        $key = $appSetting.key
        if ($configVars.$key) {
            Write-Host "Substituindo valor de AppSetting: $key com valor do bloco de variáveis"
            $appSetting.value = $configVars.$key
        }
    }
}

function Replace-ConnectionStrings-WithConfigVars {
    foreach ($connectionString in $webConfig.configuration.connectionStrings.add) {
        $name = $connectionString.name
        if ($configVars.$name) {
            Write-Host "Substituindo valor de ConnectionString: $name com valor do bloco de variáveis"
            $connectionString.connectionString = $configVars.$name
        }
    }
}

Replace-AppSettings-WithConfigVars
Replace-ConnectionStrings-WithConfigVars

$webConfig.Save($webConfigPath)

Write-Host "Substituições baseadas em variáveis de ambiente concluídas com sucesso no Web.config"