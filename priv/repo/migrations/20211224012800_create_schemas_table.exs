defmodule Rehoboam.Repo.Migrations.CreateSchemasTable do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add :description_i18n, :map
      add :file_id, references(:files, on_delete: :nilify_all)
      add :master_form_id, references(:schemas, on_delete: :delete_all)
      add :handle, :string
      add(:deleted_at, :utc_datetime)
      add(:is_latest, :boolean, default: false)
      add :description_i18n, :map
      add :private, :boolean, default: true
      add(:published_at, :utc_datetime)
      add :enable_description, :boolean, default: true
      add :enable_end_at, :boolean
      add :enable_file, :boolean
      add :enable_image, :boolean
      add :enable_location, :boolean
      add :enable_price, :boolean
      add :enable_price_compare_at, :boolean
      add :enable_start_at, :boolean
      add :enable_thumbnail, :boolean
      add :enable_title, :boolean, default: true
      add :slug, :string
      add :title_i18n, :map
      timestamps()
    end

    create index(:schemas, [:handle], unique: true, where: "master_form_id is null")
    create index(:schemas, [:slug], unique: true, where: "master_form_id is null")
  end
end
