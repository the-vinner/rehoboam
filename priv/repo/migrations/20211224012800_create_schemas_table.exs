defmodule Rehoboam.Repo.Migrations.CreateSchemasTable do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add :description_i18n, :map
      add :enable_description, :boolean, default: true
      add :enable_end_at, :boolean
      add :enable_file, :boolean
      add :enable_image, :boolean
      add :enable_location, :boolean
      add :enable_price_compare_at, :boolean
      add :enable_price, :boolean
      add :enable_start_at, :boolean
      add :enable_thumbnail, :boolean
      add :enable_title, :boolean, default: true
      add :file_id, references(:files, on_delete: :nilify_all)
      add :handle, :string
      add :private, :boolean, default: true
      add :schema_id, references(:schemas, on_delete: :delete_all)
      add :slug, :string
      add :title_i18n, :map
      add :user_id, references(:users)
      add(:deleted_at, :utc_datetime)
      add(:is_latest, :boolean, default: false)
      add(:published_at, :utc_datetime)
      timestamps()
    end

    create index(:schemas, [:handle], unique: true, where: "schema_id is null")
    create index(:schemas, [:slug], unique: true, where: "schema_id is null")
  end
end
