defmodule Rehoboam.Entries.EntryMock do
  def run do
    %{
      data_i18n: %{},
      description_i18n: %{},
      entry_master_id: "some entry_master_id",
      handle: "some handle",
      inserted_at: ~N[2022-01-30 00:57:00],
      meta_i18n: %{},
      published_at: ~U[2022-01-30 00:57:00Z],
      schema_id: "some schema_id",
      title_i18n: %{},
      updated_at: ~N[2022-01-30 00:57:00],
      user_id: "some user_id"
    }
  end

  def run_patch do
    %{
      data_i18n: %{},
      description_i18n: %{},
      entry_master_id: "some updated entry_master_id",
      handle: "some updated handle",
      id: "some updated id",
      inserted_at: ~N[2022-01-31 00:57:00],
      meta_i18n: %{},
      published_at: ~U[2022-01-31 00:57:00Z],
      schema_id: "some updated schema_id",
      title_i18n: %{},
      updated_at: ~N[2022-01-31 00:57:00],
      user_id: "some updated user_id"
    }
  end
end
