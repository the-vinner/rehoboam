defmodule Rehoboam.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :data_i18n, :map
    field :description_i18n, :map
    field :handle, :string
    field :meta_i18n, :map
    field :published_at, :utc_datetime
    field :title_i18n, :map

    belongs_to :master_entry, __MODULE__, foreign_key: :master_entry_id
    belongs_to :schema, Rehoboam.Schemas.Schema
    belongs_to :user, Rehoboam.Users.User
    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [
      :data_i18n,
      :title_i18n,
      :description_i18n,
      :meta_i18n,
      :published_at,
      :handle,
      :schema_id
    ])
    |> assoc_constraint(:schema)
    |> assoc_constraint(:user)
    |> Rehoboam.Changeset.merge_localized_map(:data_i18n, attrs)
    |> Rehoboam.Changeset.merge_localized_value(:description_i18n, attrs)
    |> Rehoboam.Changeset.merge_localized_map(:meta_i18n, attrs)
    |> Rehoboam.Changeset.merge_localized_value(:title_i18n, attrs)
    |> validate_required([:user_id, :schema_id])
  end
end
