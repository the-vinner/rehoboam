defmodule RehoboamGraphQl.Schema.FieldTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers

  node object :field do
    field :deleted_at, :datetime
    field :description_i18n, :json
    field :file, :file, resolve: dataloader(RehoboamGraphQl.Resolver.Field)
    field :file_id, :id
    field :handle, :string
    field :internal_id, :id, resolve: fn parent, _, _ -> {:ok, Map.get(parent || %{}, :id)} end
    field :image, :file, resolve: dataloader(RehoboamGraphQl.Resolver.Field)
    field :image_id, :id
    field :inserted_at, :naive_datetime
    field :is_body, :boolean
    field :is_description, :boolean
    field :is_image, :boolean
    field :is_location, :boolean
    field :is_thumbnail, :boolean
    field :is_time, :boolean
    field :is_title, :boolean
    field :meta, :json
    field :ordering, :integer
    field :placeholder_i18n, :json
    field :schema, :field, resolve: dataloader(RehoboamGraphQl.Resolver.Field)
    field :schema_id, :id
    field :title_i18n, :json
    field :type, :string
    field :updated_at, :naive_datetime
    field :user, :user, resolve: dataloader(RehoboamGraphQl.Resolver.Field)
    field :user_id, :id
    field :validations, :json
  end
  connection node_type: :field do
    field :count, non_null(:integer)
    field :count_before, non_null(:integer)
    edge do
    end
  end
  input_object :field_filters do
    field :deleted_at, :datetime
    field :description_i18n, :json
    field :file_id, :global_id
    field :handle, :string
    field :image_id, :global_id
    field :inserted_at, :naive_datetime
    field :is_body, :boolean
    field :is_description, :boolean
    field :is_image, :boolean
    field :is_location, :boolean
    field :is_thumbnail, :boolean
    field :is_time, :boolean
    field :is_title, :boolean
    field :meta, :json
    field :ordering, :integer
    field :placeholder_i18n, :json
    field :schema_id, :global_id
    field :title_i18n, :json
    field :type, :string
    field :updated_at, :naive_datetime
    field :user_id, :global_id
    field :validations, :json
  end
  input_object :field_input do
    field :deleted_at, :datetime
    field :description_i18n, :json
    field :file_id, :global_id
    field :handle, :string
    field :image_id, :global_id
    field :inserted_at, :naive_datetime
    field :is_body, :boolean
    field :is_description, :boolean
    field :is_image, :boolean
    field :is_location, :boolean
    field :is_thumbnail, :boolean
    field :is_time, :boolean
    field :is_title, :boolean
    field :meta, :json
    field :ordering, :integer
    field :placeholder_i18n, :json
    field :schema_id, :global_id
    field :title_i18n, :json
    field :type, :string
    field :updated_at, :naive_datetime
    field :user_id, :global_id
    field :validations, :json
  end
  input_object :field_filters_single do
    field :id, non_null(:global_id)
  end
  object :field_mutation_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :node, :field
    field :success_msg, :string
  end
end