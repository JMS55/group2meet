defmodule Group2meetWeb.WelcomeController do
  use Group2meetWeb, :controller

  def welcome(conn, _params) do
    oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)
    render(conn, :welcome, [layout: false, oauth_google_url: oauth_google_url])
  end
end
