defmodule Rehoboam.Assets.FileMock do
  def run do
    %{
      id: "some id",
      inserted_at: ~N[2010-04-17 14:00:00],
      file: %Plug.Upload{path: "/tmp/123"},
      mime_type: "image/png",
      title: "some title",
      title_safe: "some title_safe",
      updated_at: ~N[2010-04-17 14:00:00],
      uuid: "7488a646-e31f-11e4-aace-600308960662"
    }
  end

  def run_patch do
    %{
      id: "some updated id",
      inserted_at: ~N[2011-05-18 15:01:01],
      mime_type: "image/jpg",
      title: "some updated title",
      title_safe: "some updated title_safe",
      updated_at: ~N[2011-05-18 15:01:01],
      uuid: "7488a646-e31f-11e4-aace-600308960668"
    }
  end
end
