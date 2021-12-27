defmodule Rehoboam.Repo.Migrations.CreateSchemaFieldsTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis;"
    execute "CREATE EXTENSION IF NOT EXISTS postgis_topology;"

    create table(:schema_fields) do
      add :currency, :string
      add :deleted_at, :utc_datetime
      add :description_i18n, :map
      add :file_id, references(:files, on_delete: :nilify_all)
      add :handle, :text
      add :image_id, references(:files, on_delete: :nilify_all)
      add :is_date, :boolean
      add :is_datetime, :boolean
      add :is_email, :boolean
      add :is_phone, :boolean
      add :is_time, :boolean
      add :is_title, :boolean
      add :is_url, :boolean
      add :meta, :map
      add :ordering, :integer
      add :placeholder_i18n, :map
      add :price_cents, :integer
      add :price_cents_compare_at, :integer
      add :schema_id, references(:schemas, on_delete: :delete_all), null: false
      add :schema_master_id, references(:schemas, on_delete: :delete_all), null: false
      add :thumbnail_id, references(:files, on_delete: :nilify_all)
      add :title_i18n, :string
      add :type, :string
      add :validations, :map
      timestamps()
    end

    execute(
      "ALTER TABLE schema_fields ADD COLUMN location geography(POINT,4326)",
      "ALTER TABLE schema_fields DROPa COLUMN location"
    )

    create index("schema_fields", [:handle, :schema_master_id], unique: true)
  end
end
