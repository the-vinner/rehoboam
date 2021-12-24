defmodule RehoboamWeb.AppController do
  use RehoboamWeb, :controller
  @ssr Application.compile_env(:rehoboam, RehoboamWeb.Endpoint)[:ssr]

  def add_default_meta(conn) do
    conn
    |> assign(:title, "The Modern, Open-Source Content Engine | Rehoboam")
    |> assign(:meta_desc, "Rehoboam is a content engine that can power your websites and apps.")
  end

  def add_default_headers(conn) do
    put_resp_header(
      conn,
      "cache-control",
      "no-store, max-age=0"
    )
    |> put_resp_header(
      "vary",
      "*"
    )
  end

  def index(conn, _params) do
    use_ssr = if Map.has_key?(conn.private, :use_ssr), do: conn.private[:use_ssr], else: @ssr

    cond do
      use_ssr === true and
          not Application.get_env(:rehoboam, RehoboamWeb.Endpoint)[:use_vite_server] ->
        NodeJS.call(
          "ssr",
          [
            Map.from_struct(%RehoboamWeb.SSR{
              headers: %{
                cookie: Plug.Conn.get_req_header(conn, "cookie") |> Enum.at(0)
              },
              url: Plug.Conn.request_url(conn)
            })
          ],
          binary: true
        )
        |> case do
          {:ok, %{"html" => html, "data" => data, "meta" => meta}} ->
            conn
            |> add_default_headers
            |> render(
              "ssr.html",
              body: html,
              data: Jason.encode!(data),
              meta: meta
            )

          {:error, msg} ->
            conn
            |> send_resp(500, "Error")
        end

      use_ssr === true ->
        cookies = Plug.Conn.get_req_header(conn, "cookie") |> Enum.at(0)

        %{
          URI.parse(Plug.Conn.request_url(conn))
          | authority: "localhost:3000",
            port: 3000,
            host: "localhost",
            scheme: "http"
        }
        |> to_string
        |> then(fn url ->
          Tesla.get(
            url,
            headers:
              [
                {"content-type", "application/json"}
              ] ++ ((cookies && [{"cookie", cookies}]) || [])
          )
        end)
        |> case do
          {:ok, %Tesla.Env{body: %{"html" => _} = body}} ->
            conn
            |> add_default_headers
            |> render(
              "ssr.html",
              body: body["html"],
              data: Jason.encode!(body["data"]),
              meta: body["meta"]
            )

          err ->
            conn
            |> send_resp(500, "Error")
        end

      true ->
        conn
        |> add_default_meta
        |> add_default_headers
        |> render("index.html")
    end
  end
end
