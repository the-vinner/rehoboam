defmodule Rehoboam.Schemas.Schema do
  import Ecto.Changeset
  use Ecto.Schema

  schema "schemas" do
    field :deleted_at, :utc_datetime
    field :description, :map
    field :handle, :string
    field :is_latest, :boolean, default: false
    field :private, :boolean, default: true
    field :published_at, :utc_datetime
    field :title, :string

    belongs_to(:icon, Rehoboam.Assets.File)
    belongs_to(:image, Rehoboam.Assets.File)
    belongs_to(:schema, Rehoboam.Schemas.Schema)
    belongs_to(:user, Rehoboam.Users.User)
    has_many :fields, Rehoboam.Schemas.Field
    timestamps()
  end

  @required_fields [
    :handle,
    :user_id
  ]
  @allowed_fields [
                    :description,
                    :is_latest,
                    :private,
                    :published_at,
                    :title
                  ] ++ @required_fields

  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_fields)
    |> cast_assoc(:fields, with: &Rehoboam.Schemas.Field.changeset_cast/2)
    |> assoc_constraint(:icon)
    |> assoc_constraint(:image)
    |> assoc_constraint(:schema)
    |> assoc_constraint(:user)
    |> maybe_add_handle()
    |> ensure_handle_uniqueness
    |> unique_constraint(:handle)
    |> validate_required(@required_fields)
  end

  @spec ensure_handle_uniqueness(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def ensure_handle_uniqueness(cs) do
    Rehoboam.Changeset.ensure_field_uniqueness(
      cs,
      Rehoboam.Schemas.Schema,
      %{
        field: :handle,
        separator: "_"
      }
    )
  end

  def maybe_add_handle(%{changes: %{title: title}} = cs) when not is_nil(title) do
    if get_field(cs, :handle) do
      cs
    else
      put_change(cs, :handle, Slugger.slugify_downcase(title, ?_))
    end
  end

  def maybe_add_handle(cs), do: cs
end
