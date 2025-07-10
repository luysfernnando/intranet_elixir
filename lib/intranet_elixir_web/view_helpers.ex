defmodule IntranetElixirWeb.ViewHelpers do
  @moduledoc """
  Helpers para as views e templates
  """

  @doc """
  Trunca uma string para um tamanho específico, adicionando "..." no final
  """
  def truncate(text, opts \\ []) do
    max_length = Keyword.get(opts, :length, 100)

    if String.length(text) <= max_length do
      text
    else
      String.slice(text, 0, max_length) <> "..."
    end
  end

  @doc """
  Formata uma data para exibição
  """
  def format_date(date) do
    Calendar.strftime(date, "%d/%m/%Y")
  end

  @doc """
  Formata uma data e hora para exibição
  """
  def format_datetime(datetime) do
    Calendar.strftime(datetime, "%d/%m/%Y às %H:%M")
  end

  @doc """
  Retorna uma classe CSS para o status do post
  """
  def status_class(status) do
    case status do
      :published -> "bg-green-100 text-green-800"
      :draft -> "bg-gray-100 text-gray-800"
      :pending -> "bg-yellow-100 text-yellow-800"
      :archived -> "bg-red-100 text-red-800"
    end
  end

  @doc """
  Retorna o nome do status em português
  """
  def status_name(status) do
    case status do
      :published -> "Publicado"
      :draft -> "Rascunho"
      :pending -> "Pendente"
      :archived -> "Arquivado"
    end
  end

  @doc """
  Retorna o nome do role em português
  """
  def role_name(role) do
    case role do
      :admin -> "Administrador"
      :supervisor -> "Supervisor"
      :editor -> "Editor"
      :intern -> "Estagiário"
    end
  end

  @doc """
  Retorna uma classe CSS para o role do usuário
  """
  def role_class(role) do
    case role do
      :admin -> "bg-red-100 text-red-800"
      :supervisor -> "bg-blue-100 text-blue-800"
      :editor -> "bg-green-100 text-green-800"
      :intern -> "bg-gray-100 text-gray-800"
    end
  end

  @doc """
  Retorna opções para select de autores
  """
  def authors_options(authors) do
    Enum.map(authors, fn author ->
      {author.name, author.id}
    end)
  end

  @doc """
  Retorna opções para select de status
  """
  def status_options do
    [
      {"Rascunho", :draft},
      {"Pendente", :pending},
      {"Publicado", :published},
      {"Arquivado", :archived}
    ]
  end

  @doc """
  Retorna opções para select de roles
  """
  def role_options do
    [
      {"Administrador", :admin},
      {"Supervisor", :supervisor},
      {"Editor", :editor},
      {"Estagiário", :intern}
    ]
  end

  @doc """
  Gera uma tag de erro para um campo de formulário
  """
  def error_tag(form, field) do
    case form.errors[field] do
      nil -> nil
      error -> Phoenix.HTML.Tag.content_tag :span, translate_error(error), class: "text-red-500 text-sm"
    end
  end

  @doc """
  Traduz um erro para exibição
  """
  def translate_error({msg, opts}) do
    # Opções de tradução baseadas no Ecto.Changeset.traverse_errors/2
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def translate_error(msg), do: msg
end
