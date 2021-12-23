defmodule RehoboamGraphQl.Schema.FileTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  node object(:file) do
    field :inserted_at, :naive_datetime
    field :mime_type, :string
    field :organization_id, :global_id
    field :title, :string
    field :title_safe, :string
    field :updated_at, :naive_datetime

    field :url, :string do
      resolve(fn parent, _, _ ->
        {
          :ok,
          RehoboamGraphQl.Resolver.File.get_url(parent)
        }
      end)
    end

    field :user_id, :global_id
    field :uuid, :id
  end

  connection node_type: :file do
    field :count, non_null(:integer)
    field :count_before, non_null(:integer)

    edge do
    end
  end

  input_object :file_filters do
    field :inserted_at, :naive_datetime
    field :mime_type, :string
    field :organization_id, :global_id
    field :title, :string
    field :title_safe, :string
    field :updated_at, :naive_datetime
    field :user_id, :global_id
    field :uuid, :id
  end

  input_object :file_input do
    field :file, :upload
    field :file_url, :string
    field :inserted_at, :naive_datetime
    field :mime_type, :string
    field :organization_id, :global_id
    field :title, :string
    field :title_safe, :string
    field :updated_at, :naive_datetime
    field :user_id, :global_id
    field :uuid, :id
  end

  input_object :file_filters_single do
    field :id, non_null(:global_id)
  end

  object :file_mutation_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :node, :file
    field :success_msg, :string
  end
end
