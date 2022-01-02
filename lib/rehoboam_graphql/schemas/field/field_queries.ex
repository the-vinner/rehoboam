defmodule RehoboamGraphQl.Schema.FieldQueries do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :field_queries do
    connection field :field_collection, node_type: :field do
      # :after, :before, :first, :last added by connection
      arg :filters, non_null(:field_filters)
      arg :order, type: :sort_order, default_value: :asc
      arg :search, :string
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &RehoboamGraphQl.Resolver.Field.collection/2
    end

    field :field_single, type: :field do
      arg :filters, :field_filters_single
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &RehoboamGraphQl.Resolver.Field.one/2
    end
  end
end
