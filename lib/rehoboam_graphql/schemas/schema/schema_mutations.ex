defmodule RehoboamGraphQl.Schema.SchemaMutations do
  use Absinthe.Schema.Notation
  alias RehoboamGraphQl.Resolver

  object :schema_mutations do
    field :schema_delete, type: :schema_mutation_result do
      arg(:filters, :schema_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&Resolver.Schema.delete/2)
    end

    field :schema_mutation, type: :schema_mutation_result do
      arg(:changes, :schema_input)
      arg(:filters, :schema_filters_single)
      middleware(Potionx.Middleware.RolesAuthorization, roles: [:admin])
      resolve(&Resolver.Schema.mutation/2)
    end
  end
end
