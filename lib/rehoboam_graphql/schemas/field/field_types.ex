defmodule RehoboamGraphQl.Schema.FieldTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers

  enum :field_types do
    value :boolean
    value :checkbox
    value :custom
    value :date
    value :datetime
    value :email
    value :files
    value :images
    value :location
    value :number
    value :phone
    value :price
    value :radio
    value :select
    value :relationships
    value :text
    value :text_long
    value :text_rich
    value :time
    value :url
  end

  node object :field do
    field :deleted_at, :datetime
    field :description_i18n, :string, resolve: RehoboamGraphQl.Resolver.localize(:description_i18n)
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
    field :title_i18n, :string, resolve: RehoboamGraphQl.Resolver.localize(:title_i18n)
    field :type, :field_types
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
    field :schema_id, non_null(:global_id)
    field :title_i18n, :json
    field :type, :field_types
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
    field :type, :field_types
    field :updated_at, :naive_datetime
    field :user_id, :global_id
    field :validations, :json
  end
  input_object :field_filters_single do
    field :id, non_null(:global_id)
  end
  input_object :field_update_input do
    field :id, non_null(:global_id)
    field :ordering, non_null(:integer)
  end
  object :field_mutation_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :node, :field
    field :success_msg, :string
  end
  object :field_mutation_many_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :nodes, list_of(:field)
    field :success_msg, :string
  end
end
