defmodule IntranetElixir.Services.AuthService do
  @moduledoc """
  Service for authentication operations.
  """

  alias IntranetElixir.Accounts
  alias IntranetElixir.Guardian

  @doc """
  Authenticates a user with email and password.
  """
  def authenticate(email, password) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        {:ok, user, token}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Signs out a user by revoking their token.
  """
  def sign_out(token) do
    Guardian.revoke(token)
  end

  @doc """
  Verifies a token and returns the user.
  """
  def verify_token(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        Guardian.resource_from_claims(claims)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
