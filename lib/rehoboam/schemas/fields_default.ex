defmodule Rehoboam.Schemas.FieldDefaults do
  alias Rehoboam.Schemas.Field

  def list do
    [
      %Field{
        description_i18n: %{
          "en-US" => "Entry Title"
        },
        is_title: true,
        handle: "title",
        placeholder_i18n: %{
          "en-US" => "Title..."
        },
        title_i18n: %{
          "en-US" => "Title"
        },
        type: :text
      },
      %Field{
        description_i18n: %{
          "en-US" => "Entry body"
        },
        title_i18n: %{
          "en-US" => "Body"
        },
        handle: "body",
        type: :text_rich
      },
      %Field{
        description_i18n: %{
          "en-US" => "Entry description."
        },
        is_description: true,
        placeholder_i18n: %{
          "en-US" => "Description..."
        },
        title_i18n: %{
          "en-US" => "Description"
        },
        handle: "description",
        type: :text_long
      },
      %Field{
        description_i18n: %{
          "en-US" => "Entry images."
        },
        handle: "images",
        is_image: true,
        title_i18n: %{
          "en-US" => "Images"
        },
        type: :images
      },
      %Field{
        description_i18n: %{
          "en-US" => "Entry thumbnails."
        },
        handle: "thumbnails",
        is_thumbnail: true,
        title_i18n: %{
          "en-US" => "Thumbnails"
        },
        type: :images
      }
    ]
  end

  def seed(repo) do
    list()
    |> Enum.map(fn field ->
      repo.get_by(Field, handle: field.handle)
      |> case do
        nil ->
          repo.insert!(%{
            field
            | inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
              updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
          })

        _ ->
          :ok
      end
    end)
  end
end
