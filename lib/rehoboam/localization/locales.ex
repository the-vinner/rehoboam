defmodule Rehoboam.Localization.Locale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locales" do
    field :locale, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(locales, attrs) do
    locales
    |> cast(attrs, [:locale, :title])
    |> validate_required([:locale, :title])
    |> unique_constraint(:locale)
  end
end
