# Intranet Elixir

Um sistema de intranet moderno desenvolvido com Elixir/Phoenix, seguindo o padrão KISS (Keep It Simple, Stupid) para facilitar manutenção e desenvolvimento.

## 🚀 Características

- **Portal de Notícias**: Interface moderna similar a um portal de notícias
- **Sistema de Autenticação**: Integrado com Guardian JWT
- **Níveis de Permissão**: 4 tipos de usuários com permissões específicas
- **Painel Administrativo**: Interface completa para gerenciamento
- **Temas Customizáveis**: Sistema de cores, logo e favicon personalizáveis
- **Responsivo**: Interface adaptada para dispositivos móveis
- **Servidor Caddy**: Configuração otimizada para produção

## 👥 Níveis de Permissão

### Admin
- Gerencia usuários (criar, editar, excluir, desabilitar)
- Acesso completo a todos os CRUDs
- Gerencia temas do sistema

### Supervisor  
- Aprova posts e páginas de estagiários
- Deleta posts e páginas
- Cria e edita conteúdo sem necessidade de aprovação

### Editor
- Cria e edita posts e páginas
- Publica conteúdo sem aprovação
- Acesso ao painel administrativo

### Estagiário
- Cria e edita posts e páginas
- Conteúdo precisa de aprovação (supervisor/admin)
- Acesso ao painel administrativo

## 🛠 Tecnologias Utilizadas

- **Backend**: Elixir 1.14+ / Phoenix 1.7+
- **Banco de Dados**: PostgreSQL
- **Autenticação**: Guardian JWT
- **Frontend**: Phoenix LiveView + Tailwind CSS
- **Servidor**: Caddy Server
- **Assets**: esbuild + Tailwind CSS

## 📦 Instalação e Configuração

### Pré-requisitos

- Elixir 1.14 ou superior
- Erlang/OTP 25 ou superior
- PostgreSQL 13 ou superior
- Node.js 18 ou superior (para assets)
- Caddy Server (opcional, para produção)

### 1. Clone o repositório

```bash
git clone https://github.com/luysfernnando/intranet_elixir.git
cd intranet_elixir
```

### 2. Instale as dependências

```bash
# Dependências Elixir
mix deps.get

# Dependências Node.js
cd assets && npm install && cd ..
```

### 3. Configure o banco de dados

Edite o arquivo `config/dev.exs` com suas credenciais do PostgreSQL:

```elixir
config :intranet_elixir, IntranetElixir.Repo,
  username: "seu_usuario",
  password: "sua_senha",
  hostname: "localhost",
  database: "intranet_elixir_dev"
```

### 4. Configure as chaves secretas

```bash
# Gere uma chave secreta para o Phoenix
mix phx.gen.secret

# Gere uma chave secreta para o Guardian
mix guardian.gen.secret
```

Atualize os arquivos de configuração com as chaves geradas.

### 5. Execute as migrações

```bash
mix ecto.setup
```

Este comando irá:
- Criar o banco de dados
- Executar as migrações
- Executar os seeds (criando usuário admin padrão)

### 6. Compile os assets

```bash
mix assets.setup
mix assets.build
```

### 7. Inicie o servidor

```bash
mix phx.server
```

A aplicação estará disponível em `http://localhost:4000`

## 📋 Usuários Padrão

Após executar os seeds, você terá:

- **Email**: admin@intranet.com
- **Senha**: 123456
- **Perfil**: Admin

## 🎨 Estrutura do Projeto

```
lib/
├── intranet_elixir/
│   ├── accounts/           # Contexto de usuários
│   ├── content/           # Contexto de conteúdo (posts/páginas)
│   ├── settings/          # Contexto de configurações/temas
│   └── services/          # Serviços de negócio
├── intranet_elixir_web/
│   ├── controllers/       # Controllers públicos
│   ├── controllers/admin/ # Controllers do painel admin
│   ├── components/        # Componentes Phoenix
│   └── templates/         # Templates HTML
```

## 🎯 Funcionalidades Principais

### Portal Público
- Listagem de posts publicados
- Visualização de posts individuais
- Páginas estáticas
- Sistema de login

### Painel Administrativo
- Dashboard com estatísticas
- Gerenciamento de usuários (admin)
- Gerenciamento de posts
- Gerenciamento de páginas
- Sistema de aprovação para estagiários
- Configuração de temas

### Sistema de Aprovação
- Posts e páginas de estagiários ficam pendentes
- Supervisores e admins podem aprovar conteúdo
- Status visível no painel administrativo

## 🚀 Deploy com Caddy

### 1. Configure o Caddyfile

O projeto já inclui um `Caddyfile` configurado. Para produção, edite:

```
seu-dominio.com {
    reverse_proxy localhost:4000
    
    tls {
        dns seu_provedor {env.DNS_API_TOKEN}
    }
}
```

### 2. Configure variáveis de ambiente

```bash
export SECRET_KEY_BASE="sua_chave_secreta"
export GUARDIAN_SECRET_KEY="sua_chave_guardian"
export DATABASE_URL="postgres://user:pass@localhost/intranet_elixir_prod"
```

### 3. Execute em produção

```bash
MIX_ENV=prod mix assets.deploy
_build/prod/rel/intranet_elixir/bin/intranet_elixir start
```

## 🧪 Testes

```bash
# Execute todos os testes
mix test

# Execute testes específicos
mix test test/intranet_elixir/accounts_test.exs
```

## 🎨 Personalização de Temas

O sistema permite customização completa através do painel administrativo:

1. Acesse `/admin/themes`
2. Crie um novo tema ou edite existente
3. Configure cores primárias, secundárias e de destaque
4. Faça upload de logo e favicon
5. Ative o tema desejado

## 📁 Estrutura de Pastas Importantes

```
assets/
├── css/
│   └── app.css           # Estilos principais com Tailwind
├── js/
│   └── app.js           # JavaScript customizado
└── package.json         # Dependências Node.js

priv/
├── repo/
│   ├── migrations/      # Migrações do banco
│   └── seeds.exs        # Dados iniciais
└── static/             # Assets compilados

config/
├── config.exs          # Configuração geral
├── dev.exs             # Configuração desenvolvimento
├── prod.exs            # Configuração produção
└── runtime.exs         # Configuração runtime
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

## 📝 Convenções do Código

- **Controllers**: Sufixo `_controller`
- **Serviços**: Sufixo `_service`
- **Testes**: Sufixo `_test`
- **Padrão KISS**: Código simples e direto ao ponto

## 🔒 Segurança

- Tokens JWT para autenticação
- Headers de segurança configurados no Caddy
- Validação de permissões em todos os endpoints
- Proteção CSRF ativada
- Sanitização de inputs

## 📞 Suporte

Para questões ou sugestões:

1. Abra uma [Issue](https://github.com/luysfernnando/intranet_elixir/issues)
2. Entre em contato via email
3. Consulte a documentação do Phoenix

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE.md](LICENSE.md) para detalhes.

---

**Desenvolvido com ❤️ usando Elixir e Phoenix**
