defmodule RehoboamGraphQl.Schema.SchemaQueries do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :schema_queries do
    connection field :schema_collection, node_type: :schema do
      # :after, :before, :first, :last added by connection
      arg(:filters, :schema_filters)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:search, :string)
      middleware(RehoboamGraphQl.Middleware.Filters, %{published: false})
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.Schema.collection/2)
    end

    connection field :schema_published_collection, node_type: :schema do
      # :after, :before, :first, :last added by connection
      arg(:filters, :schema_filters)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:search, :string)
      middleware(RehoboamGraphQl.Middleware.Filters, %{is_latest: true, published: true})
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.Schema.collection/2)
    end

    field :schema_single, type: :schema do
      arg(:filters, :schema_filters_single)
      middleware(RehoboamGraphQl.Middleware.Filters, %{published: false})
      resolve(&RehoboamGraphQl.Resolver.Schema.one/2)
    end

    field :schema_published_single, type: :schema do
      arg(:filters, :schema_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.Schema.one/2)
    end
  end
end
