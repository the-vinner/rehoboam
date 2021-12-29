defmodule Rehoboam.Schemas.SchemaField do
  import Ecto.Changeset
  use Ecto.Schema

  schema "schema_fields" do
    field :deleted_at, :utc_datetime
    field :description_i18n, :map
    field :handle, :string
    field :is_body, :boolean
    field :is_description, :boolean
    field :is_image, :boolean
    field :is_location, :boolean
    field :is_thumbnail, :boolean
    field :is_time, :boolean
    field :is_title, :boolean
    field :meta, :map
    field :placeholder_i18n, :map
    field :title_i18n, :map

    field :validations, :map
    field :type, Ecto.Enum,
      values: [
        :boolean,
        :checkbox,
        :custom,
        :date,
        :datetime,
        :email,
        :files,
        :images,
        :location,
        :number,
        :phone,
        :price,
        :radio,
        :select,
        :relationships,
        :text,
        :text_long,
        :text_rich,
        :time,
        :url
      ]
    belongs_to :file, Rehoboam.Assets.File
    belongs_to :image, Rehoboam.Assets.File
    belongs_to :user, Rehoboam.Users.User
  end
end
