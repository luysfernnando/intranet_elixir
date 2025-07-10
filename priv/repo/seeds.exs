defmodule IntranetElixir.Repo.Seeds do
  @moduledoc """
  Script for populating the database with initial data.
  """

  alias IntranetElixir.Repo
  alias IntranetElixir.Accounts.User
  alias IntranetElixir.Settings.Theme
  alias IntranetElixir.Content.Post
  alias IntranetElixir.Content.Page

  def run do
    create_admin_user()
    create_default_theme()
    create_sample_content()
  end

  defp create_admin_user do
    case Repo.get_by(User, email: "admin@intranet.com") do
      nil ->
        %User{}
        |> User.changeset(%{
          name: "Administrador",
          email: "admin@intranet.com",
          password: "123456",
          role: :admin,
          active: true
        })
        |> Repo.insert!()

      _user ->
        :ok
    end
  end

  defp create_default_theme do
    case Repo.get_by(Theme, name: "Default") do
      nil ->
        %Theme{}
        |> Theme.changeset(%{
          name: "Default",
          primary_color: "#3B82F6",
          secondary_color: "#64748B",
          accent_color: "#10B981",
          active: true
        })
        |> Repo.insert!()

      _theme ->
        :ok
    end
  end

  defp create_sample_content do
    admin_user = Repo.get_by(User, email: "admin@intranet.com")

    if admin_user do
      create_sample_posts(admin_user)
      create_sample_pages(admin_user)
    end
  end

  defp create_sample_posts(user) do
    sample_posts = [
      %{
        title: "Introdução ao Elixir",
        content: "Elixir é uma linguagem de programação dinâmica e funcional projetada para criar aplicações mantíveis e escaláveis. Neste post, vamos explorar os conceitos básicos da linguagem.",
        excerpt: "Aprenda os conceitos básicos da linguagem Elixir",
        categories_string: "programação, elixir, tutorial",
        tags_string: "elixir, funcional, erlang, iniciante",
        status: :published,
        published_at: NaiveDateTime.utc_now()
      },
      %{
        title: "Phoenix Framework: Guia Completo",
        content: "Phoenix é um framework web para Elixir que oferece alta performance e produtividade. Neste guia completo, vamos aprender a criar aplicações web robustas.",
        excerpt: "Guia completo sobre o Phoenix Framework",
        categories_string: "web, phoenix, tutorial",
        tags_string: "phoenix, web, mvc, liveview",
        status: :published,
        published_at: NaiveDateTime.utc_now()
      },
      %{
        title: "Banco de Dados com Ecto",
        content: "Ecto é a biblioteca de banco de dados para Elixir que oferece um DSL poderoso para queries e migrações. Aprenda a trabalhar com bancos de dados de forma eficiente.",
        excerpt: "Aprenda a trabalhar com bancos de dados usando Ecto",
        categories_string: "banco-de-dados, ecto, tutorial",
        tags_string: "ecto, postgresql, database, migrations",
        status: :published,
        published_at: NaiveDateTime.utc_now()
      }
    ]

    Enum.each(sample_posts, fn post_attrs ->
      post_attrs = Map.put(post_attrs, :user_id, user.id)

      case Repo.get_by(Post, title: post_attrs.title) do
        nil ->
          %Post{}
          |> Post.changeset(post_attrs)
          |> Repo.insert!()
        _post ->
          :ok
      end
    end)
  end

  defp create_sample_pages(user) do
    sample_pages = [
      %{
        title: "Sobre Nós",
        content: "Nossa empresa é especializada em desenvolvimento de software usando tecnologias modernas como Elixir e Phoenix. Oferecemos soluções escaláveis e de alta qualidade.",
        excerpt: "Conheça nossa empresa e nossos serviços",
        categories_string: "empresa, sobre",
        tags_string: "empresa, equipe, serviços",
        status: :published,
        published_at: NaiveDateTime.utc_now()
      },
      %{
        title: "Política de Privacidade",
        content: "Esta política de privacidade descreve como coletamos, usamos e protegemos suas informações pessoais quando você utiliza nossos serviços.",
        excerpt: "Nossa política de privacidade e proteção de dados",
        categories_string: "legal, privacidade",
        tags_string: "privacidade, lgpd, dados, legal",
        status: :published,
        published_at: NaiveDateTime.utc_now()
      },
      %{
        title: "Contato",
        content: "Entre em contato conosco através dos canais disponíveis. Estamos sempre prontos para ajudar com suas dúvidas e necessidades.",
        excerpt: "Como entrar em contato conosco",
        categories_string: "contato, suporte",
        tags_string: "contato, suporte, atendimento",
        status: :published,
        published_at: NaiveDateTime.utc_now()
      }
    ]

    Enum.each(sample_pages, fn page_attrs ->
      page_attrs = Map.put(page_attrs, :user_id, user.id)

      case Repo.get_by(Page, title: page_attrs.title) do
        nil ->
          %Page{}
          |> Page.changeset(page_attrs)
          |> Repo.insert!()
        _page ->
          :ok
      end
    end)
  end
end

IntranetElixir.Repo.Seeds.run()
