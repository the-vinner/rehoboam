defmodule Rehoboam.Schemas.Schema do
  import Ecto.Changeset
  use Ecto.Schema

  schema "schemas" do
    field :deleted_at, :utc_datetime
    field :description_i18n, :map
    field :enable_description, :boolean, default: true
    field :enable_end_at, :boolean
    field :enable_file, :boolean
    field :enable_image, :boolean
    field :enable_location, :boolean
    field :enable_price_compare_at, :boolean
    field :enable_price, :boolean
    field :enable_start_at, :boolean
    field :enable_thumbnail, :boolean
    field :enable_title, :boolean, default: true
    field :handle, :string
    field :is_latest, :boolean, default: false
    field :private, :boolean, default: true
    field :published_at, :utc_datetime
    field :slug, :string
    field :title_i18n, :map

    belongs_to(:file, Rehoboam.Assets.File)
    belongs_to(:schema, Rehoboam.Schemas.Schema)
    belongs_to(:user, Rehoboam.Users.User)
    timestamps()
  end

  @required_fields [
    :user_id
  ]
  @allowed_fields [
    :description_i18n,
    :enable_description,
    :enable_end_at,
    :enable_file,
    :enable_image,
    :enable_location,
    :enable_price,
    :enable_price_compare_at,
    :enable_start_at,
    :enable_thumbnail,
    :enable_title,
    :handle,
    :is_latest,
    :private,
    :published_at,
    :slug,
    :title_i18n
  ] ++ @required_fields

  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_fields)
    |> assoc_constraint(:file)
    |> assoc_constraint(:schema)
    |> assoc_constraint(:user)
    |> validate_required(@required_fields)
  end
end
