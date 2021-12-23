defmodule Rehoboam.Assets.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "files" do
    field :mime_type, :string
    field :title, :string
    field :title_safe, :string
    field :uuid, Ecto.UUID
    belongs_to :user, Rehoboam.Users.User

    timestamps()
  end

  @doc false
  def changeset(file, attrs, validations \\ %{}) do
    attrs = file_to_attrs(attrs)

    file
    |> cast(attrs, [:title, :title_safe, :mime_type])
    |> handle_additional_validations(validations)
    |> maybe_generate_title_safe
    |> validate_format(:mime_type, ~r/^image\//)
    |> validate_required([:title, :title_safe, :mime_type, :uuid])
  end

  def ext(name) do
    if String.contains?(name, ".") do
      name |> String.split(".") |> Enum.at(-1)
    else
      ""
    end
  end

  def file_to_attrs(%{file: %Plug.Upload{} = file} = attrs) do
    Map.merge(
      %{
        mime_type: file.content_type,
        title: file.filename
      },
      attrs
    )
  end

  def file_to_attrs(attrs), do: attrs

  def handle_additional_validations(%Ecto.Changeset{} = cs, validations)
      when is_list(validations) do
    Enum.reduce(validations, cs, fn {fn_valid, {field, params}}, cs ->
      apply(Ecto.Changeset, fn_valid, [cs, field, params])
    end)
  end

  def handle_additional_validations(%Ecto.Changeset{} = cs, _), do: cs

  def maybe_generate_title_safe(changeset) do
    case get_field(changeset, :id) do
      nil ->
        put_change(
          changeset,
          :title_safe,
          title_to_title_safe(get_field(changeset, :title) || "")
        )

      _ ->
        changeset
    end
  end

  def title_to_title_safe(name) do
    name_no_ext = name |> String.split(".") |> Enum.at(0)
    Slugger.slugify(name_no_ext) <> "." <> ext(name)
  end

  def type(%File{mime_type: mime_type}) do
    String.split(mime_type, "/")
    |> Enum.at(1)
  end
end
