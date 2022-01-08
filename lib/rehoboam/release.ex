defmodule Rehoboam.Release do
  @app :rehoboam
  alias Rehoboam.Localization.Locale
  alias Rehoboam.Users.User

  defp ensure_repo_created(repo) do
    IO.puts("create #{inspect(repo)} database if it doesn't exist")

    case repo.__adapter__.storage_up(repo.config) do
      :ok -> :ok
      {:error, :already_up} -> :ok
      {:error, term} -> {:error, term}
    end
  end


  def seed_locales(repo) do
    Locale.defaults()
    |> Enum.each(fn locale ->
      repo.get_by(Locale, locale: locale.locale)
      |> case do
        nil ->
          repo.insert!(locale)

        _ ->
          :ok
      end
    end)
  end

  def migrate do
    load_app()

    for repo <- repos() do
      :ok = ensure_repo_created(repo)
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))

      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, fn repo ->
          seed_locales(repo)
          seed(repo)
        end)
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  def seed(repo) do
    email = Application.fetch_env!(@app, :root_user_email)

    if email do
      repo.get_by(User, email: email)
      |> case do
        nil ->
          repo.insert!(%User{
            email: email,
            roles: [:admin]
          })

        _ ->
          :ok
      end
    end
  end

  defp load_app do
    Application.load(@app)
  end
end
