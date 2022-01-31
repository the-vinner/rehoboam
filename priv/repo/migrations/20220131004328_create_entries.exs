defmodule Rehoboam.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :data_i18n, :map
      add :description_i18n, :map
      add :handle, :string
      add :master_entry_id, references(:entries, on_delete: :delete_all), null: false
      add :meta_i18n, :map
      add :published_at, :utc_datetime
      add :schema_id, references(:schemas, on_delete: :delete_all), null: false
      add :title_i18n, :map
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end
    create index("entries", [:schema_id])
  end
end
