defmodule Rehoboam.Schemas.SchemaMock do
  def run do
    %{
      deleted_at: ~U[2021-12-23 03:36:00Z],
      description_i18n: %{},
      enable_description: true,
      enable_end_at: true,
      enable_file: true,
      enable_image: true,
      enable_location: true,
      enable_price: true,
      enable_price_compare_at: true,
      enable_start_at: true,
      enable_thumbnail: true,
      enable_title: true,
      file_id: "some file_id",
      handle: "some handle",
      id: "some id",
      inserted_at: ~N[2021-12-23 03:36:00],
      is_latest: true,
      private: true,
      published_at: ~U[2021-12-23 03:36:00Z],
      schema_id: "some schema_id",
      slug: "some slug",
      title_i18n: %{},
      updated_at: ~N[2021-12-23 03:36:00]
    }
  end

  def run_patch do
    %{
      deleted_at: ~U[2021-12-24 03:36:00Z],
      description_i18n: %{},
      enable_description: false,
      enable_end_at: false,
      enable_file: false,
      enable_image: false,
      enable_location: false,
      enable_price: false,
      enable_price_compare_at: false,
      enable_start_at: false,
      enable_thumbnail: false,
      enable_title: false,
      file_id: "some updated file_id",
      handle: "some updated handle",
      id: "some updated id",
      inserted_at: ~N[2021-12-24 03:36:00],
      is_latest: false,
      private: false,
      published_at: ~U[2021-12-24 03:36:00Z],
      schema_id: "some updated schema_id",
      slug: "some updated slug",
      title_i18n: %{},
      updated_at: ~N[2021-12-24 03:36:00]
    }
  end
end
