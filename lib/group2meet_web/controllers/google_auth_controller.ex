defmodule Group2meetWeb.GoogleAuthController do
  use Group2meetWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    user = Group2meet.App.create_user(%{auth_id: profile.sub, name: profile.name})
    IO.inspect(user)
    conn
    |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/1")
  end
end
