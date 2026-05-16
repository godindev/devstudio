# WezTerm configurações

## Arquivo de configuração

Para alterar o caminho das configurações padrão do WezTerm e centralizar em um único local.

### Windows

1. Criar a variável de ambiente `WEZTERM_CONFIG_FILE`.
2. Apontar para o arquivo `wezterm.lua`. 

Exemplo: 

```pwsh
$env:WEZTERM_CONFIG_FILE = '%USERPROFILE%\.devstudio\configs\wezterm\wezterm.lua'
```