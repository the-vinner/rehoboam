defmodule Rehoboam.Localization.Locale do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

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

  def default do
    defaults() |> Enum.at(0)
  end

  def defaults do
    [
      %Locale{
        locale: "en-US",
        title: "English"
      },
      %Locale{
        locale: "es-ES",
        title: "Español"
      },
      %Locale{
        locale: "fr-FR",
        title: "Français"
      }
    ]
  end
end
