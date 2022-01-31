defmodule RehoboamGraphQl.Schema.EntryTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers

  node object :entry do
    field :data_i18n, :json
    field :description_i18n, :json
    field :entry_master, :entry, resolve: dataloader(RehoboamGraphQl.Resolver.Entry)
    field :entry_master_id, :id
    field :handle, :string
    field :internal_id, :id, resolve: fn parent, _, _ -> {:ok, Map.get(parent || %{}, :id)} end
    field :inserted_at, :naive_datetime
    field :meta_i18n, :json
    field :published_at, :datetime
    field :schema, :schema, resolve: dataloader(RehoboamGraphQl.Resolver.Entry)
    field :schema_id, :id
    field :title_i18n, :json
    field :updated_at, :naive_datetime
    field :user, :user, resolve: dataloader(RehoboamGraphQl.Resolver.Entry)
    field :user_id, :id
  end
  connection node_type: :entry do
    field :count, non_null(:integer)
    field :count_before, non_null(:integer)
    edge do
    end
  end
  input_object :entry_filters do
    field :data_i18n, :json
    field :description_i18n, :json
    field :entry_master_id, :global_id
    field :handle, :string
    field :inserted_at, :naive_datetime
    field :meta_i18n, :json
    field :published_at, :datetime
    field :schema_id, :global_id
    field :title_i18n, :json
    field :updated_at, :naive_datetime
    field :user_id, :global_id
  end
  input_object :entry_input do
    field :data_i18n, :json
    field :description_i18n, :json
    field :entry_master_id, :global_id
    field :handle, :string
    field :inserted_at, :naive_datetime
    field :meta_i18n, :json
    field :published_at, :datetime
    field :schema_id, :global_id
    field :title_i18n, :json
    field :updated_at, :naive_datetime
    field :user_id, :global_id
  end
  input_object :entry_filters_single do
    field :id, non_null(:global_id)
  end
  object :entry_mutation_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :node, :entry
    field :success_msg, :string
  end
end