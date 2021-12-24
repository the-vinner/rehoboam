defmodule Rehoboam.Users.User do
  import Ecto.Changeset
  use Ecto.Schema
  alias __MODULE__
  @behaviour Potionx.Auth.User

  schema "users" do
    field :bio, :string
    field :deleted_at, :utc_datetime
    field :email, :string
    field :name_first, :string
    field :name_last, :string
    field :roles, {:array, Ecto.Enum}, values: [:admin, :author, :guest]
    field :slug, :string

    has_many :user_identities, Rehoboam.UserIdentities.UserIdentity

    belongs_to :file, Rehoboam.Assets.File
    timestamps()
  end

  defimpl Jason.Encoder, for: User do
    def encode(s, opts) do
      s
      |> Map.from_struct()
      |> Map.drop([:__meta__, :file, :file_id, :user_identities, :user_subscriptions])
      |> Jason.Encode.map(opts)
    end
  end

  def assent_attrs_to_changes(attrs) do
    [
      {"family_name", :name_last},
      {"given_name", :name_first},
      {"locale", :locale},
      {"name", :name_first}
    ]
    |> Enum.reduce(attrs, fn {key_from, key_to}, acc ->
      if Map.has_key?(acc, key_from) do
        Map.put(
          acc,
          to_string(key_to),
          Map.get(acc, key_from)
        )
      else
        Map.put(
          acc,
          to_string(key_from),
          Map.get(acc, key_from)
        )
      end
    end)
  end

  def changeset(user_or_changeset, attrs) do
    # attrs = assent_attrs_to_changes(attrs)
    user_or_changeset
    |> cast(attrs, [
      :bio,
      :file_id,
      :name_first,
      :name_last,
      :roles,
      :slug
    ])
    |> validate_subset(
      :roles,
      Ecto.Enum.values(__MODULE__, :roles)
    )
    |> maybe_add_slug
    |> ensure_slug_uniqueness
    |> validate_required([:email, :slug])
    |> validate_length(:bio, max: 1000)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def ensure_slug_uniqueness(%{valid?: false} = cs) do
    cs
  end

  def ensure_slug_uniqueness(cs) do
    Rehoboam.Changeset.ensure_field_uniqueness(
      cs,
      User
    )
  end

  def from_json(%{id: _} = user) do
    user
  end

  def from_json(%{"roles" => roles} = user) do
    roles = roles || []

    params =
      Map.new(user, fn
        {k, v} ->
          {String.to_existing_atom(k), v}
      end)
      |> Map.put(:roles, Enum.map(roles, &String.to_existing_atom(&1)))

    struct(User, params)
  end

  def maybe_add_slug(%{changes: %{name_first: name, name_last: surname}} = cs)
      when not is_nil(name) and not is_nil(surname) do
    if get_field(cs, :slug) do
      cs
    else
      put_change(cs, :slug, String.slice(name, 0, 1) <> surname)
    end
  end

  def maybe_add_slug(cs), do: cs

  def sanitize_bio(%{changes: %{bio: c}} = cs) when not is_nil(c) do
    put_change(cs, :bio, HtmlSanitizeEx.html5(c))
  end

  def sanitize_bio(cs), do: cs

  def title(entry) do
    [entry.name_first, entry.name_last]
    |> Enum.filter(fn e -> e end)
    |> Enum.join(" ")
  end
end
