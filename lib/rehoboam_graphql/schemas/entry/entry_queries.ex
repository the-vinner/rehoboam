defmodule RehoboamGraphQl.Schema.EntryQueries do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :entry_queries do
    connection field :entry_collection, node_type: :entry do
      # :after, :before, :first, :last added by connection
      arg :filters, :entry_filters
      arg :order, type: :sort_order, default_value: :asc
      arg :search, :string
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &RehoboamGraphQl.Resolver.Entry.collection/2
    end

    field :entry_single, type: :entry do
      arg :filters, :entry_filters_single
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &RehoboamGraphQl.Resolver.Entry.one/2
    end
  end
end