defmodule Rehoboam.Repo.Migrations.CreateSchemasTable do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add(:deleted_at, :utc_datetime)
      add :description, :string
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
