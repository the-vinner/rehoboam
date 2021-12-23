defmodule RehoboamGraphQl.Schema.UserMutations do
  use Absinthe.Schema.Notation
  alias RehoboamGraphQl.Resolver

  object :user_mutations do
    field :user_delete, type: :user_mutation_result do
      arg(:filters, :user_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&Resolver.User.delete/2)
    end

    field :user_mutation, type: :user_mutation_result do
      arg(:changes, :user_input)
      arg(:filters, :user_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])

      middleware(fn
        %{context: %Potionx.Context.Service{filters: %{id: "me"}, user: %{id: id}} = ctx} = res,
        _ ->
          %{res | context: %Potionx.Context.Service{filters: %{ctx.filters | id: id}}}

        res, _ ->
          res
      end)

      resolve(&Resolver.User.mutation/2)
    end

    field :user_me_mutation, type: :user_mutation_result do
      arg(:changes, :user_public_input)
      arg(:filters, :user_filters_single)
      middleware(RehoboamGraphQl.Middleware.Me)
      middleware(RehoboamGraphQl.Middleware.MeLatest)
      resolve(&Resolver.User.mutation/2)
    end
  end
end
