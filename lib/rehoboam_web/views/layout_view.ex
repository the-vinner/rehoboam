defmodule RehoboamWeb.LayoutView do
  use RehoboamWeb, :view
  @cdn_url Application.compile_env(:rehoboam, RehoboamWeb.Endpoint)[:cdn_url]

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def is_prod do
    Application.get_env(:rehoboam, :env) === :prod
  end

  def metas do
    []
  end

  def scripts do
    unless Application.get_env(:rehoboam, RehoboamWeb.Endpoint)[:use_vite_server] do
      File.read(Path.join(:code.priv_dir(:rehoboam), "static/admin/client/manifest.json"))
      |> case do
        {:ok, file} ->
          file
          |> Jason.decode!()
          |> case do
            %{"src/entry-client.ts" => %{"file" => file}} ->
              [Path.join([@cdn_url, "/admin/client/", file])]

            _ ->
              []
          end

        {:error, _} ->
          []
      end
    else
      [
        "http://localhost:3000/@vite/client",
        "http://localhost:3000/src/entry-client.ts"
      ]
    end
  end

  def strip_tags(content) do
    HtmlSanitizeEx.strip_tags(content)
  end

  def stylesheets do
    unless Application.get_env(:rehoboam, RehoboamWeb.Endpoint)[:use_vite_server] do
      File.read(Path.join(:code.priv_dir(:rehoboam), "static/admin/client/manifest.json"))
      |> case do
        {:ok, file} ->
          file
          |> Jason.decode!()
          |> case do
            %{"src/entry-client.ts" => %{"css" => css}} ->
              Enum.map(css, fn file ->
                Path.join([@cdn_url, "/admin/client/", file])
              end)

            _ ->
              []
          end

        {:error, _} ->
          []
      end
    else
      []
    end
  end
end
