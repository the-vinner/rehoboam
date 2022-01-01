defmodule Rehoboam.FileUpload do
  use TypedStruct

  typedstruct do
    field :mime_type, :string, enforce: true
    field :title_safe, String.t(), enforce: true
    field :path, String.t(), enforce: true
    field :public, boolean()
    field :uuid, String.t(), enforce: true
    field :type, String.t(), enforce: true
  end

  @callback get_url(%{type: String.t(), title_safe: String.t(), uuid: String.t()}, String.t()) :: String.t()
  @callback upload(Rehoboam.FileUpload.t()) :: {:ok, any()} | {:error, any()}
end
