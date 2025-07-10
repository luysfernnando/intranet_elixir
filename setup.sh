#!/bin/bash

# Script de setup para o projeto Intranet Elixir
# Execute: chmod +x setup.sh && ./setup.sh

echo "🚀 Iniciando configuração do projeto Intranet Elixir..."

# Verifica se o Elixir está instalado
if ! command -v elixir &> /dev/null; then
    echo "❌ Elixir não encontrado. Instale o Elixir antes de continuar."
    exit 1
fi

# Verifica se o PostgreSQL está rodando
if ! pg_isready &> /dev/null; then
    echo "⚠️  PostgreSQL não está rodando. Certifique-se de que está instalado e rodando."
    echo "   Ubuntu/Debian: sudo service postgresql start"
    echo "   macOS: brew services start postgresql"
    exit 1
fi

# Verifica se o Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado. Instale o Node.js 18+ antes de continuar."
    exit 1
fi

echo "✅ Dependências do sistema verificadas"

# Instala dependências Elixir
echo "📦 Instalando dependências Elixir..."
mix deps.get

# Instala dependências Node.js
echo "📦 Instalando dependências Node.js..."
cd assets && npm install && cd ..

# Gera chaves secretas se não existirem
echo "🔑 Verificando chaves secretas..."
if ! grep -q "YourSecretKeyBaseHere" config/dev.exs; then
    echo "   Chaves já configuradas"
else
    echo "   Gerando novas chaves secretas..."
    SECRET_KEY=$(mix phx.gen.secret)
    GUARDIAN_SECRET=$(mix guardian.gen.secret)
    
    # Substitui as chaves nos arquivos de configuração
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/YourSecretKeyBaseHere123456789012345678901234567890123456789012345678901234567890/$SECRET_KEY/g" config/dev.exs
        sed -i '' "s/YourGuardianSecretKey123456789012345678901234567890123456789012345678901234567890/$GUARDIAN_SECRET/g" config/dev.exs
    else
        # Linux
        sed -i "s/YourSecretKeyBaseHere123456789012345678901234567890123456789012345678901234567890/$SECRET_KEY/g" config/dev.exs
        sed -i "s/YourGuardianSecretKey123456789012345678901234567890123456789012345678901234567890/$GUARDIAN_SECRET/g" config/dev.exs
    fi
fi

# Configuração do banco de dados
echo "🗄️  Configurando banco de dados..."
read -p "Digite o usuário do PostgreSQL (padrão: postgres): " DB_USER
DB_USER=${DB_USER:-postgres}

read -s -p "Digite a senha do PostgreSQL: " DB_PASSWORD
echo

# Atualiza configuração do banco
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/username: \"postgres\"/username: \"$DB_USER\"/g" config/dev.exs
    sed -i '' "s/password: \"postgres\"/password: \"$DB_PASSWORD\"/g" config/dev.exs
else
    sed -i "s/username: \"postgres\"/username: \"$DB_USER\"/g" config/dev.exs
    sed -i "s/password: \"postgres\"/password: \"$DB_PASSWORD\"/g" config/dev.exs
fi

# Cria banco e executa migrações
echo "🏗️  Criando banco e executando migrações..."
mix ecto.setup

# Compila assets
echo "🎨 Compilando assets..."
mix assets.setup
mix assets.build

# Cria diretórios necessários
echo "📁 Criando diretórios necessários..."
mkdir -p priv/static/uploads
mkdir -p logs

echo "✅ Configuração concluída!"
echo ""
echo "🎉 Para iniciar o servidor:"
echo "   mix phx.server"
echo ""
echo "📝 Acesse a aplicação em: http://localhost:4000"
echo ""
echo "👤 Usuário admin padrão:"
echo "   Email: admin@intranet.com"
echo "   Senha: 123456"
echo ""
echo "🔧 Para desenvolvimento com live reload:"
echo "   mix phx.server"
echo ""
echo "📚 Consulte o README.md para mais informações."
