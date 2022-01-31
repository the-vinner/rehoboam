defmodule RehoboamGraphQl.Schema.EntryMutations do
  use Absinthe.Schema.Notation
  alias RehoboamGraphQl.Resolver

  object :entry_mutations do
    field :entry_delete, type: :entry_mutation_result do
      arg :filters, :entry_filters_single
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &Resolver.Entry.delete/2
    end

    field :entry_mutation, type: :entry_mutation_result do
      arg :changes, :entry_input
      arg :filters, :entry_filters_single
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &Resolver.Entry.mutation/2
    end
  end
end