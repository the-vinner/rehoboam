defmodule RehoboamGraphQl.Schema.FieldMutations do
  use Absinthe.Schema.Notation
  alias RehoboamGraphQl.Resolver

  object :field_mutations do
    field :field_delete, type: :field_mutation_result do
      arg :filters, :field_filters_single
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &Resolver.Field.delete/2
    end

    field :field_mutation, type: :field_mutation_result do
      arg :changes, :field_input
      arg :filters, :field_filters_single
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin]]
      resolve &Resolver.Field.mutation/2
    end

    field :field_ordering_mutation, type: :field_mutation_many_result do
      arg :fields, list_of(:field_update_input)
      middleware Potionx.Middleware.RolesAuthorization, [roles: [:admin, :editor]]
      resolve &Resolver.Field.mutation_ordering/2
    end
  end
end
