defmodule RehoboamWeb.PageController do
  use RehoboamWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
