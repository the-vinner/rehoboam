defmodule Rehoboam.Repo.Migrations.CreateSchemaFieldsTable do
  use Ecto.Migration

  def change do
    create table(:schema_fields) do
      add :description_i18n, :map
      add :meta, :map
      add :handle, :text
      add :deleted_at, :utc_datetime
      add :is_date, :boolean
      add :is_datetime, :boolean
      add :is_email, :boolean
      add :is_phone, :boolean
      add :is_time, :boolean
      add :is_title, :boolean
      add :is_url, :boolean
      add :ordering, :integer
      add :placeholder_i18n, :map
      add :schema_id, references(:schemas, on_delete: :delete_all), null: false
      add :title_i18n, :string
      add :type, :string
      add :validations, :map
      timestamps()
    end

    create index("schema_fields", [:handle, :schema_id], unique: true)
  end
end
