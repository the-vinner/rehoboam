defmodule Rehoboam.Repo.Migrations.CreateSchemaFieldsTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis;", "DROP EXTENSION postgis"
    execute "CREATE EXTENSION IF NOT EXISTS postgis_topology;", "DROP EXTENSION postgis_topology"

    create table(:schema_fields) do
      add :deleted_at, :utc_datetime
      add :description_i18n, :map
      add :file_id, references(:files, on_delete: :nilify_all)
      add :handle, :text
      add :image_id, references(:files, on_delete: :nilify_all)
      add :is_body, :boolean
      add :is_description, :boolean
      add :is_image, :boolean
      add :is_location, :boolean
      add :is_thumbnail, :boolean
      add :is_time, :boolean
      add :is_title, :boolean
      add :meta, :map
      add :placeholder_i18n, :map
      add :title_i18n, :map

      add :type, :string
      add :user_id, references(:users, on_delete: :nilify_all)
      add :validations, :map
      timestamps()
    end

    create index("schema_fields", [:handle], unique: true)
  end
end
