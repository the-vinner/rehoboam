defmodule RehoboamGraphQl.Schema.FileQueries do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :file_queries do
    connection field :file_collection, node_type: :file do
      # :after, :before, :first, :last added by connection
      arg(:filters, :file_filters)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:search, :string)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.File.collection/2)
    end

    field :file_single, type: :file do
      arg(:filters, :file_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.File.one/2)
    end
  end
end
