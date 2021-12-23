defmodule Rehoboam.FileUpload do
  use TypedStruct
  alias __MODULE__

  typedstruct do
    field :mime_type, :string, enforce: true
    field :title_safe, String.t(), enforce: true
    field :path, String.t(), enforce: true
    field :public, boolean()
    field :uuid, String.t(), enforce: true
    field :type, String.t(), enforce: true
  end

  @callback upload(FileUpload.t()) :: {:ok, any()} | {:error, any()}
end
