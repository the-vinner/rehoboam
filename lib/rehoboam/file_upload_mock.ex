defmodule Rehoboam.FileUploadMock do
  @behaviour Rehoboam.FileUpload

  @impl true
  def get_url(%{type: _, title_safe: _, uuid: _} = ctx, _) do
    Enum.join(
    [ctx.title_safe, ctx.uuid],
      "/"
    )
  end

  @impl true
  def upload(%Rehoboam.FileUpload{}) do
    {:ok, "success"}
  end
end
