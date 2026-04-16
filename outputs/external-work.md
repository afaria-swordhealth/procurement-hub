# External Work Log
<!-- Drop file for non-procurement sessions to report work into the daily log. -->
<!-- Format: ## Project — YYYY-MM-DD, then 3-5 bullets. Cleared by /wrap-up after inclusion in daily log. -->

## LogMan Update — 2026-04-16
- Reestruturou pasta APP/ para distribuição: .py + launchers Mac/Windows + README numa só pasta zipável
- Reescreveu install_mac.command: usa Python do python.org (sem Xcode CLT), auto-download do instalador se não existir, venv isolado
- Criou diagnose_mac.command (troubleshooting) e reset_mac.command (limpeza completa para reinstalação)
- Adicionou GitHub Actions workflow (test-mac-install.yml) com 3 cenários: Mac limpo, Mac com Python, diagnóstico — todos a passar
- Instalou e configurou gh CLI para consultar Actions diretamente
