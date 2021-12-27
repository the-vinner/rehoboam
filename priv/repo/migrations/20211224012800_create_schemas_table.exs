defmodule Rehoboam.Repo.Migrations.CreateSchemasTable do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add(:deleted_at, :utc_datetime)
      add :description, :string
      add :enable_description, :boolean, default: true
      add :enable_end_at, :boolean, default: false
      add :enable_file, :boolean, default: true
      add :enable_image, :boolean, default: true
      add :enable_link, :boolean, default: false
      add :enable_location, :boolean, default: false
      add :enable_price_compare_at, :boolean, default: false
      add :enable_price, :boolean, default: false
      add :enable_relationship, :boolean, default: false
      add :enable_start_at, :boolean, default: false
      add :enable_thumbnail, :boolean, default: false
      add :enable_title, :boolean, default: true
      add :icon_id, references(:files, on_delete: :nilify_all)
      add :image_id, references(:files, on_delete: :nilify_all)
      add :handle, :string
      add :private, :boolean, default: true
      add :schema_id, references(:schemas, on_delete: :delete_all)
      add :title, :string
      add :user_id, references(:users)
      add(:is_latest, :boolean, default: false)
      add(:published_at, :utc_datetime)
      timestamps()
    end

    create index(:schemas, [:handle], unique: true, where: "schema_id is null")
  end
end
