function Show-AsciiBanner {
    $banner = @"
  ____              ____  _             _ _       
 |  _ \  _____   __/ ___|| |_ _   _  __| (_) ___  
 | | | |/ _ \ \ / /\___ \| __| | | |/ _` | |/ _ \ 
 | |_| |  __/\ V /  ___) | |_| |_| | (_| | | (_) |
 |____/ \___| \_/  |____/ \__|\__,_|\__,_|_|\___/ 
                                                  
"@

    Write-Host $banner -ForegroundColor Cyan
}

Show-AsciiBanner

# ------------------------------
# ETAPA INICIAL
# ------------------------------

Write-Host "🔧 Configurando política de execução..."
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Write-Host "✔ Política de execução configurada.`n"

# ------------------------------
# CONFIGURAÇÕES
# ------------------------------

$programs = @(
    # Ferramental
    @{ Name = "Flameshot"; WingetId = "Flameshot.Flameshot" },
    @{ Name = "Draw.io"; WingetId = "JGraph.Draw" },
    @{ Name = "7zip"; WingetId = "7zip.7zip" },
    # Dev Ferramental
    @{ Name = "Git"; WingetId = "Git.Git" },
    @{ Name = "cURL"; WingetId = "cURL.cURL" },
    @{ Name = "WezTerm"; WingetId = "wez.wezterm" },
    @{ Name = "Pnpm"; ScriptUrl = "Invoke-WebRequest https://get.pnpm.io/install.ps1 -UseBasicParsing | Invoke-Expression" },
    @{ Name = "Scoop"; ScriptUrl = "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression" },  
    # SDKs
    @{ Name = "Java SDK"; WingetId = "EclipseAdoptium.Temurin.25.JDK" },
    @{ Name = ".NET SDK 10"; WingetId = "Microsoft.DotNet.SDK.10" },
    @{ Name = "Go"; WingetId = "GoLang.Go" },
    # Editores e IDE
    @{ Name = "Neovim"; WingetId = "Neovim.Neovim" },
    @{ Name = "VSCode"; WingetId = "Microsoft.VisualStudioCode" }, 
    @{ Name = "JetBrains IntelliJ"; WingetId = "JetBrains.IntelliJIDEA" },
    @{ Name = "JetBrains Rider"; WingetId = "JetBrains.Rider" },
    @{ Name = "DBEaver"; WingetId = "DBeaver.DBeaver.Community" },
    @{ Name = "GitHub Copilot CLI"; WingetId = "GitHub.Copilot" },
    # Navegadores
    @{ Name = "Google Chrome"; WingetId = "Google.Chrome" },
    @{ Name = "Microsoft Edge"; WingetId = "Microsoft.Edge" },
    @{ Name = "Brave"; WingetId = "Brave.Brave" },
    # Diversos
    @{ Name = "Oh My Posh"; WingetId = "JanDeDobbeleer.OhMyPosh" },
    @{ Name = "Discord"; WingetId = "Discord.Discord" },
    
)

# ------------------------------
# FUNÇÕES
# ------------------------------

function Program-Installed {
    param([string]$ProgramName)
    $result = winget list --name $ProgramName 2>$null
    return ($result -match $ProgramName)
}

function Start-InstallJob {
    param($Program)

    if (Program-Installed $Program.Name) {
        Write-Host "✔ $Program.Name já instalado."
        return $null
    }

    Write-Host "⬇ Iniciando instalação de $Program.Name..."

    # Instalação via WinGet
    if ($Program.WingetId) {
        return Start-Job -ScriptBlock {
            param($Name, $WingetId)
            winget install --id $WingetId --silent --accept-package-agreements --accept-source-agreements
            return "$Name instalado via WinGet"
        } -ArgumentList $Program.Name, $Program.WingetId
    }

    # Instalação via script externo
    if ($Program.ScriptUrl) {
        return Start-Job -ScriptBlock {
            param($Name, $Url)

            $temp = "$env:TEMP\install_temp.ps1"
            Invoke-WebRequest -Uri $Url -OutFile $temp
            Invoke-Expression (Get-Content $temp -Raw)

            return "$Name instalado via script externo"
        } -ArgumentList $Program.Name, $Program.ScriptUrl
    }

    Write-Host "⚠ Nenhum método de instalação encontrado para $($Program.Name)"
    return $null
}

# ------------------------------
# EXECUÇÃO PARALELA
# ------------------------------

$jobs = @()

foreach ($p in $programs) {
    $job = Start-InstallJob $p
    if ($job) { $jobs += $job }
}

$total = $jobs.Count
$completed = 0

while ($completed -lt $total) {
    foreach ($job in $jobs) {
        if ($job.State -eq "Completed" -and -not $job.Processed) {
            $completed++
            $job.Processed = $true
        }
    }

    Write-Progress -Activity "Instalando programas..." `
                   -Status "$completed de $total concluídos" `
                   -PercentComplete (($completed / $total) * 100)

    Start-Sleep -Milliseconds 300
}

Write-Progress -Activity "Instalação concluída!" -Completed

# Coleta resultados
foreach ($job in $jobs) {
    Receive-Job $job
    Remove-Job $job
}

Write-Host "🎉 Todas as instalações foram finalizadas!"