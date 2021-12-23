defmodule Rehoboam.FileUploadMock do
  @behaviour Rehoboam.FileUpload

  def upload(%Rehoboam.FileUpload{}) do
    {:ok, "success"}
  end
end
