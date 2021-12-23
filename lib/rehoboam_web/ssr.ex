defmodule RehoboamWeb.SSR do
  use TypedStruct

  typedstruct do
    field :headers, :map, enforce: true
    field :url, :string, enforce: true
  end
end
