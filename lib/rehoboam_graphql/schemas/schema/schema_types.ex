defmodule RehoboamGraphQl.Schema.SchemaTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers

  node object(:schema) do
    field :deleted_at, :datetime
    field :description_i18n, :string, resolve: RehoboamGraphQl.Resolver.localize(:description_i18n)
    field :file, :file, resolve: dataloader(RehoboamGraphQl.Resolver.Schema)
    field :file_id, :id
    field :handle, :string
    field :internal_id, :id, resolve: fn parent, _, _ -> {:ok, Map.get(parent || %{}, :id)} end
    field :inserted_at, :naive_datetime
    field :is_latest, :boolean
    field :private, :boolean
    field :published_at, :datetime
    field :schema, :schema, resolve: dataloader(RehoboamGraphQl.Resolver.Schema)
    field :schema_id, :id
    field :slug, :string
    field :title_i18n, :string, resolve: RehoboamGraphQl.Resolver.localize(:title_i18n)
    field :file, :file, resolve: dataloader(RehoboamGraphQl.Resolver.Schema)
    # field :fields, list_of(:field), resolve: dataloader(RehoboamGraphQl.Resolver.Schema)
    field :updated_at, :naive_datetime
    field :user, :user, resolve: dataloader(RehoboamGraphQl.Resolver.Schema)
    field :user_id, :id
  end

  connection node_type: :schema do
    field :count, non_null(:integer)
    field :count_before, non_null(:integer)

    edge do
    end
  end

  input_object :schema_filters do
    field :deleted_at, :datetime
    field :description, :string
    field :file_id, :global_id
    field :handle, :string
    field :inserted_at, :naive_datetime
    field :is_latest, :boolean
    field :private, :boolean
    field :published_at, :datetime
    field :master_schema_id, :global_id
    field :slug, :string
    field :title, :string
    field :updated_at, :naive_datetime
    field :user_id, :global_id
  end

  input_object :schema_input do
    field :deleted_at, :datetime
    field :description_i18n, :localized
    field :file_id, :global_id
    field :handle, :string
    field :inserted_at, :naive_datetime
    field :is_latest, :boolean
    field :private, :boolean
    field :published_at, :datetime
    field :master_schema_id, :global_id
    field :slug, :string
    field :title_i18n, :localized
    field :updated_at, :naive_datetime
    field :user_id, :global_id
  end

  input_object :schema_filters_single do
    field :id, non_null(:global_id)
  end

  object :schema_mutation_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :node, :schema
    field :success_msg, :string
  end
end
