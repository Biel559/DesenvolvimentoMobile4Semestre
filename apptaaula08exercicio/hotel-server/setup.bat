@echo off
echo Configurando servidor JSON Server para S&M Hotel...
echo.

REM Verificar se Node.js está instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Node.js nao esta instalado!
    echo Por favor, instale Node.js de: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js encontrado!
echo.

REM Instalar dependências
echo Instalando json-server...
npm install

if %errorlevel% neq 0 (
    echo ERRO: Falha ao instalar dependencias
    pause
    exit /b 1
)

echo.
echo Instalacao concluida!
echo.
echo Iniciando servidor na porta 3000...
echo Pressione Ctrl+C para parar o servidor
echo.

npm start