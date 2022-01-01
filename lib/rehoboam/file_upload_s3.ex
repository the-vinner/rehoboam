defmodule Rehoboam.FileUploadS3 do
  @app_name Application.compile_env(:ex_aws, :s3)[:app]
  @behaviour Rehoboam.FileUpload

  @spec file_name(map()) :: String.t()
  def file_name(%{uuid: uuid, title_safe: title_safe}) do
    Enum.join([uuid, title_safe], "/")
  end

  @spec get_path(map()) :: String.t()
  def get_path(%{type: type, title_safe: _, uuid: _} = ctx) do
    Enum.join([type, file_name(ctx)], "/")
  end

  @impl true
  def get_url(%{type: _, title_safe: _, uuid: _} = ctx, _) do
    Enum.join(
      ["//", get_path(ctx)],
      "/"
    )
  end

  @impl true
  def upload(%Rehoboam.FileUpload{} = ctx) do
    ExAws.S3.put_object(
      @app_name,
      get_path(ctx),
      File.read!(ctx.path),
      acl: (ctx.public && "public-read") || "private",
      content_type: ctx.mime_type
    )
    |> ExAws.request()
  end
end
