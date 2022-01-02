defmodule Rehoboam.Schemas.SchemaMock do
  def run do
    %{
      deleted_at: ~U[2021-12-23 03:36:00Z],
      description_i18n: %{},
      file_id: "some file_id",
      handle: "some handle",
      id: "some id",
      inserted_at: ~N[2021-12-23 03:36:00],
      is_latest: true,
      private: true,
      published_at: ~U[2021-12-23 03:36:00Z],
      schema_id: "some schema_id",
      slug: "some slug",
      title_i18n: Map.put(%{}, Rehoboam.Localization.Locale.default().locale, "title"),
      updated_at: ~N[2021-12-23 03:36:00]
    }
  end

  def run_patch do
    %{
      deleted_at: ~U[2021-12-24 03:36:00Z],
      description_i18n: %{},
      file_id: "some updated file_id",
      handle: "some updated handle",
      id: "some updated id",
      inserted_at: ~N[2021-12-24 03:36:00],
      is_latest: false,
      private: false,
      published_at: ~U[2021-12-24 03:36:00Z],
      schema_id: "some updated schema_id",
      slug: "some updated slug",
      title_i18n: Map.put(%{}, Rehoboam.Localization.Locale.default().locale, "title2"),
      updated_at: ~N[2021-12-24 03:36:00]
    }
  end
end
