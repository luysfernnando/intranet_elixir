defmodule IntranetElixirWeb.ErrorHTML do
  use IntranetElixirWeb, :html

  # Custom error pages for specific status codes
  def render("404.html", _assigns) do
    """
    <!DOCTYPE html>
    <html lang="pt-br">
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Página não encontrada - Intranet</title>
        <link rel="stylesheet" href="/assets/app.css"/>
    </head>
    <body class="bg-gray-100">
        <div class="min-h-screen flex items-center justify-center">
            <div class="max-w-md w-full bg-white shadow-lg rounded-lg p-8 text-center">
                <div class="mb-4">
                    <h1 class="text-6xl font-bold text-gray-400 mb-2">404</h1>
                    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Página não encontrada</h2>
                </div>
                <p class="text-gray-600 mb-6">
                    Desculpe, a página que você está procurando não existe ou foi movida.
                </p>
                <div class="space-y-2">
                    <a href="/" class="inline-block bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg transition duration-200">
                        Voltar ao início
                    </a>
                    <br>
                    <a href="/admin" class="inline-block text-blue-500 hover:text-blue-600 font-medium">
                        Ir para o painel administrativo
                    </a>
                </div>
            </div>
        </div>
    </body>
    </html>
    """
  end

  def render("500.html", _assigns) do
    """
    <!DOCTYPE html>
    <html lang="pt-br">
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Erro interno do servidor - Intranet</title>
        <link rel="stylesheet" href="/assets/app.css"/>
    </head>
    <body class="bg-gray-100">
        <div class="min-h-screen flex items-center justify-center">
            <div class="max-w-md w-full bg-white shadow-lg rounded-lg p-8 text-center">
                <div class="mb-4">
                    <h1 class="text-6xl font-bold text-red-400 mb-2">500</h1>
                    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Erro interno do servidor</h2>
                </div>
                <p class="text-gray-600 mb-6">
                    Ops! Algo deu errado. Nosso time técnico foi notificado e está trabalhando para resolver o problema.
                </p>
                <div class="space-y-2">
                    <a href="/" class="inline-block bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg transition duration-200">
                        Voltar ao início
                    </a>
                    <br>
                    <a href="/admin" class="inline-block text-blue-500 hover:text-blue-600 font-medium">
                        Ir para o painel administrativo
                    </a>
                </div>
            </div>
        </div>
    </body>
    </html>
    """
  end

  # The default is to return the status message from the template name
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
