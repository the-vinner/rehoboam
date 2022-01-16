defmodule Rehoboam.Schemas.Field do
  alias __MODULE__
  import Ecto.Changeset
  import Ecto.Query
  use Ecto.Schema

  schema "fields" do
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
    field :ordering, :integer
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
    belongs_to :schema, Rehoboam.Schemas.Field
    belongs_to :image, Rehoboam.Assets.File
    belongs_to :user, Rehoboam.Users.User
    timestamps()
  end

  @required_fields [
    :handle,
    :ordering,
    :schema_id,
    :type,
    :user_id
  ]
  @allowed_fields [
                    :is_body,
                    :is_description,
                    :handle,
                    :is_body,
                    :is_image,
                    :is_location,
                    :is_thumbnail,
                    :is_time,
                    :is_title,
                    :meta,
                    :validations,
                    :type
                  ] ++ @required_fields

  def adjust_ordering(cs) do
    cs
    |> prepare_changes(fn changeset ->
      ordering_next = get_change(changeset, :ordering)
      ordering_current = changeset.data.ordering
      schema_id = get_field(changeset, :schema_id)
      query = from(f in Field, where: f.schema_id == ^schema_id)

      cond do
        is_nil(ordering_current) ->
          from(f in query, where: f.ordering <= ^ordering_next)
          |> changeset.repo.update_all(inc: [ordering: 1])

        ordering_current > ordering_next ->
          from(f in query, where: f.ordering >= ^ordering_next and f.ordering < ^ordering_current)
          |> changeset.repo.update_all(inc: [ordering: 1])

        ordering_current < ordering_next ->
          from(f in query, where: f.ordering <= ^ordering_next and f.ordering > ^ordering_current)
          |> changeset.repo.update_all(inc: [ordering: -1])

        true ->
          nil
      end

      changeset
    end)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @allowed_fields)
    |> maybe_add_handle(params)
    |> ensure_handle_uniqueness
    |> Rehoboam.Changeset.merge_localized_value(:description_i18n, params)
    |> Rehoboam.Changeset.merge_localized_value(:placeholder_i18n, params)
    |> Rehoboam.Changeset.merge_localized_value(:title_i18n, params)
    |> constrain_ordering
    |> adjust_ordering
    |> unique_constraint([:handle, :schema_id])
    |> validate_required(@required_fields)
  end

  def changeset_cast(struct, params) do
    struct
    |> cast(params, @allowed_fields)
    |> maybe_add_handle(params)
    |> Rehoboam.Changeset.merge_localized_value(:description_i18n, params)
    |> Rehoboam.Changeset.merge_localized_value(:placeholder_i18n, params)
    |> Rehoboam.Changeset.merge_localized_value(:title_i18n, params)
    |> unique_constraint([:handle, :schema_id])
    |> validate_required([:handle])
  end

  def constrain_ordering(cs) do
    if ordering = get_change(cs, :ordering) do
      schema_id = get_field(cs, :schema_id)
      max = Rehoboam.Repo.one(from(f in Field, where: f.schema_id == ^schema_id, select: count())) - 1
      put_change(cs, :ordering, Kernel.max(0, ordering) |> Kernel.min(max))
    else
      cs
    end
  end

  @spec ensure_handle_uniqueness(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def ensure_handle_uniqueness(cs) do
    schema_id = get_field(cs, :schema_id)

    if schema_id do
      Rehoboam.Changeset.ensure_field_uniqueness(
        cs,
        from(f in Rehoboam.Schemas.Field, where: f.schema_id == ^schema_id),
        [
          field: :handle,
          separator: "_"
        ]
      )
    else
      cs
    end
  end

  def maybe_add_handle(cs, %{title_i18n: title}) when not is_nil(title) do
    title = Map.values(title) |> Enum.at(0)

    if get_field(cs, :handle) || is_nil(title) do
      cs
    else
      put_change(cs, :handle, Slugger.slugify_downcase(title, ?_))
    end
  end

  def maybe_add_handle(cs, _), do: cs
end
