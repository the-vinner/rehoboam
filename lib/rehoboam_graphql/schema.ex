defmodule RehoboamGraphQl.Schema do
  use Potionx.Schema

  node interface do
    resolve_type(fn
      %Rehoboam.Schemas.Field{}, _ ->
        :field
      %Rehoboam.Schemas.Schema{}, _ ->
        :schema

      %Rehoboam.Assets.File{}, _ ->
        :file

      %Rehoboam.Users.User{}, _ ->
        :user

      %Rehoboam.UserIdentities.UserIdentity{}, _ ->
        :user_identity

      _, _ ->
        nil
    end)
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  def dataloader do
    Dataloader.new()
    |> Dataloader.add_source(RehoboamGraphQl.Resolver.User, RehoboamGraphQl.Resolver.User.data())
    |> Dataloader.add_source(RehoboamGraphQl.Resolver.File, RehoboamGraphQl.Resolver.File.data())
    |> Dataloader.add_source(
      RehoboamGraphQl.Resolver.Schema,
      RehoboamGraphQl.Resolver.Schema.data()
    )
    |> Dataloader.add_source(RehoboamGraphQl.Resolver.Field, RehoboamGraphQl.Resolver.Field.data())
  end

  def get_key(%{source: source} = res, key) do
    Map.get(source, key)
    |> case do
      nil ->
        Map.get(source, to_string(key))

      val ->
        val
    end
    |> (fn value ->
          %{res | state: :resolved, value: value}
        end).()
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    Enum.concat([
      [
        {Potionx.Middleware.UserRequired,
         [
           exceptions:
             [] ++
               [
                 :session_renew,
                 :sign_in_provider
               ]
         ]},
        Potionx.Middleware.ServiceContext
      ],
      middleware,
      [
        Potionx.Middleware.ChangesetErrors,
        Potionx.Middleware.Mutation
      ]
    ])
  end

  def middleware(middleware, _field, %{identifier: :query}) do
    [
      Potionx.Middleware.ServiceContext
    ] ++ middleware
  end

  def middleware(middleware, %{identifier: identifier} = field, object) do
    new_middleware_spec = {{__MODULE__, :get_key}, identifier}
    Absinthe.Schema.replace_default(middleware, new_middleware_spec, field, object)
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  query do
    import_fields(:user_queries)
    import_fields(:file_queries)
    import_fields(:schema_queries)
    import_fields :field_queries
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:auth_mutations)
    import_fields(:file_mutations)
    import_fields(:schema_mutations)
    import_fields :field_mutations
  end

  interface :rehoboam_mutation do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :success_msg, :string
  end

  scalar :localized do
    parse(fn
      %{value: v}, %Potionx.Context.Service{locale: locale, locale_default: locale_default} ->
        {:ok, Map.put(%{}, to_string(locale || locale_default), v)}
      _, _ ->
        {:ok, nil}
    end)
  end

  import_types(RehoboamGraphQl.Schema.AuthMutations)
  import_types(RehoboamGraphQl.Schema.UserIdentityTypes)
  import_types(RehoboamGraphQl.Schema.UserMutations)
  import_types(RehoboamGraphQl.Schema.UserQueries)
  import_types(RehoboamGraphQl.Schema.UserTypes)
  import_types(RehoboamGraphQl.Schema.FileMutations)
  import_types(RehoboamGraphQl.Schema.FileQueries)
  import_types(RehoboamGraphQl.Schema.FileTypes)
  import_types(RehoboamGraphQl.Schema.SchemaMutations)
  import_types(RehoboamGraphQl.Schema.SchemaQueries)
  import_types(RehoboamGraphQl.Schema.SchemaTypes)
  import_types RehoboamGraphQl.Schema.FieldMutations
  import_types RehoboamGraphQl.Schema.FieldQueries
  import_types RehoboamGraphQl.Schema.FieldTypes
end