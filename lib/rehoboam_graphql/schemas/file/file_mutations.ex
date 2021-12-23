defmodule RehoboamGraphQl.Schema.FileMutations do
  use Absinthe.Schema.Notation
  alias RehoboamGraphQl.Resolver

  object :file_mutations do
    field :file_delete, type: :file_mutation_result do
      arg(:filters, :file_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      middleware(Potionx.Middleware.ScopeUser)
      resolve(&Resolver.File.delete/2)
    end

    field :file_mutation, type: :file_mutation_result do
      arg(:changes, :file_input)
      arg(:filters, :file_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      middleware(Potionx.Middleware.ScopeUser)
      resolve(&Resolver.File.mutation/2)
    end
  end
end
