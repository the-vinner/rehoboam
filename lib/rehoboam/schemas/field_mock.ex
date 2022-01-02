defmodule Rehoboam.Schemas.FieldMock do
  def run do
    %{
      deleted_at: ~U[2022-01-01 20:14:00Z],
      description_i18n: %{},
      file_id: "some file_id",
      handle: "some handle",
      id: "some id",
      image_id: "some image_id",
      inserted_at: ~N[2022-01-01 20:14:00],
      is_body: true,
      is_description: true,
      is_image: true,
      is_location: true,
      is_thumbnail: true,
      is_time: true,
      is_title: true,
      meta: %{},
      ordering: 42,
      placeholder_i18n: %{},
      schema_id: "some schema_id",
      title_i18n: %{},
      type: "some type",
      updated_at: ~N[2022-01-01 20:14:00],
      user_id: "some user_id",
      validations: %{}
    }
  end

  def run_patch do
    %{
      deleted_at: ~U[2022-01-02 20:14:00Z],
      description_i18n: %{},
      file_id: "some updated file_id",
      handle: "some updated handle",
      id: "some updated id",
      image_id: "some updated image_id",
      inserted_at: ~N[2022-01-02 20:14:00],
      is_body: false,
      is_description: false,
      is_image: false,
      is_location: false,
      is_thumbnail: false,
      is_time: false,
      is_title: false,
      meta: %{},
      ordering: 43,
      placeholder_i18n: %{},
      schema_id: "some updated schema_id",
      title_i18n: %{},
      type: "some updated type",
      updated_at: ~N[2022-01-02 20:14:00],
      user_id: "some updated user_id",
      validations: %{}
    }
  end
end
