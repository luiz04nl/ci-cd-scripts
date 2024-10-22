$webConfigPath = "src/Web.config"
$newConfigsPath = "src/Web.Debug.config"

[xml]$webConfig = Get-Content $webConfigPath
[xml]$newConfig = Get-Content $newConfigsPath

function Replace-AppSettings {
    foreach ($newConfigItem in $newConfig.configuration.appSettings.add) {
        $key = $newConfigItem.key
        $existingSetting = $webConfig.configuration.appSettings.add | Where-Object { $_.key -eq $key }
        if ($existingSetting) {
            $existingSetting.value = $newConfigItem.value
        } else {
            $newElement = $webConfig.CreateElement("add")
            $newElement.SetAttribute("key", $key)
            $newElement.SetAttribute("value", $newConfigItem.value)
            $webConfig.configuration.appSettings.AppendChild($newElement)
        }
    }
}

function Replace-ConnectionStrings {
    foreach ($newConnectionItem in $newConfig.configuration.connectionStrings.add) {
        $name = $newConnectionItem.name
        $existingConnection = $webConfig.configuration.connectionStrings.add | Where-Object { $_.name -eq $name }
        if ($existingConnection) {
            $existingConnection.connectionString = $newConnectionItem.connectionString
        } else {
            $newElement = $webConfig.CreateElement("add")
            $newElement.SetAttribute("name", $name)
            $newElement.SetAttribute("connectionString", $newConnectionItem.connectionString)
            $newElement.SetAttribute("providerName", $newConnectionItem.providerName)
            $webConfig.configuration.connectionStrings.AppendChild($newElement)
        }
    }
}

Replace-AppSettings
Replace-ConnectionStrings

$webConfig.Save($webConfigPath)

Write-Host "Substituições concluídas com sucesso no Web.config"