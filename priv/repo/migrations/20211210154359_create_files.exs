defmodule Rehoboam.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add(:title, :string)
      add(:mime_type, :string)
      add(:title_safe, :string)
      add(:uuid, :uuid)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    alter table(:users) do
      add(:file_id, references(:files))
    end

    create(index(:files, [:user_id]))
  end
end
