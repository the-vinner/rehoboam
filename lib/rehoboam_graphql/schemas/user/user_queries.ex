defmodule RehoboamGraphQl.Schema.UserQueries do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :user_queries do
    connection field :user_collection, node_type: :user do
      arg(:filters, :user_filters)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:search, :string)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.User.collection/2)
    end

    connection field :user_public_collection, node_type: :user_public do
      arg(:filters, :user_filters)
      arg(:order, type: :sort_order, default_value: :asc)
      arg(:search, :string)
      middleware(Potionx.Middleware.UserRequired)
      resolve(&RehoboamGraphQl.Resolver.User.collection/2)
    end

    field :user_public_single, type: :user_public do
      arg(:filters, :user_filters_single)
      resolve(&RehoboamGraphQl.Resolver.User.one/2)
    end

    field :user_single, type: :user do
      arg(:filters, :user_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&RehoboamGraphQl.Resolver.User.one/2)
    end

    field :me, type: :user do
      middleware(RehoboamGraphQl.Middleware.MeLatest)
      resolve(&RehoboamGraphQl.Resolver.User.me/2)
    end
  end
end
