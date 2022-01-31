defmodule RehoboamGraphQl.Schema do
  use Potionx.Schema
  @prototype_schema RehoboamGraphQl.SchemaPrototype
  @schema_provider Absinthe.Schema.PersistentTerm
  # @pipeline_modifier []

  @doc false
  # def __absinthe_pipeline_modifiers__ do
  #   [@schema_provider]
  # end

  def __absinthe_schema_provider__ do
    @schema_provider
  end

  def __absinthe_type__({name, schema_name}) do
    @schema_provider.__absinthe_type__(schema_name, name)
  end

  def __absinthe_type__(name) do
    @schema_provider.__absinthe_type__(__MODULE__, name)
  end

  def __absinthe_directive__(name, schema_name) do
    @schema_provider.__absinthe_directive__(schema_name, name)
  end

  def __absinthe_types__() do
    @schema_provider.__absinthe_types__(__MODULE__)
  end

  def __absinthe_types__(group) do
    @schema_provider.__absinthe_types__(__MODULE__, group)
  end

  def __absinthe_directives__() do
    @schema_provider.__absinthe_directives__(__MODULE__)
  end

  def __absinthe_interface_implementors__() do
    @schema_provider.__absinthe_interface_implementors__(__MODULE__)
  end

  def __absinthe_prototype_schema__() do
    @prototype_schema
  end

  def hydrate(%Absinthe.Blueprint.Schema.FieldDefinition{identifier: id}, [%Absinthe.Blueprint.Schema.ObjectTypeDefinition{identifier: :query} | _]) do
    {:resolve, &__MODULE__.queries/3}
  end
  def hydrate(_node, _ancestors), do: []

  # Resolver implementation:
  def queries(a, b, c) do
    {:ok, %{id: "1"}}
  end

  node interface do
    resolve_type(fn
      %Rehoboam.Entries.Entry{}, _ ->
        :entry
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
    |> Dataloader.add_source(
      RehoboamGraphQl.Resolver.Field,
      RehoboamGraphQl.Resolver.Field.data()
    )
    |> Dataloader.add_source(RehoboamGraphQl.Resolver.Entry, RehoboamGraphQl.Resolver.Entry.data())
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
    import_fields(:field_queries)
    import_fields :entry_queries
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:auth_mutations)
    import_fields(:file_mutations)
    import_fields(:schema_mutations)
    import_fields(:field_mutations)
    import_fields :entry_mutations
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

  scalar :localized_map do
    parse(fn
      %{value: v}, %Potionx.Context.Service{locale: locale, locale_default: locale_default} ->
        value = not is_nil(v) && is_binary(v) && Jason.decode!(v) || nil
        {:ok, Map.put(%{}, to_string(locale || locale_default), value)}

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
  import_types(RehoboamGraphQl.Schema.FieldMutations)
  import_types(RehoboamGraphQl.Schema.FieldQueries)
  import_types(RehoboamGraphQl.Schema.FieldTypes)

  def combine_types(definitions, identifier, fields_to_add) do
    index = Enum.find_index(definitions, fn def -> def.identifier === identifier end)
    parent = Enum.at(definitions, index)
    parent = %{parent | fields: parent.fields ++ fields_to_add}
    List.replace_at(definitions, index, parent)
  end

  @spec rebuild(sdl :: Absinthe.Language.Source.t() | Absinthe.Language.Blueprint.t()) :: any()
  def rebuild(sdl) do
    prototype_schema = __absinthe_prototype_schema__()
    blueprint = %Absinthe.Blueprint{schema: __MODULE__}
    attrs = [blueprint]
    schema_def = __absinthe_blueprint__().schema_definitions |> Enum.at(0)

    {:ok, definitions} =
      Absinthe.Schema.Notation.SDL.parse(
        sdl,
        __MODULE__,
        Absinthe.Schema.Notation.build_reference(__ENV__),
        []
      )

    query_fields =
      (Enum.find(definitions, fn obj -> obj.identifier === :query end) || %{fields: []})
      |> Map.get(:fields)

    mutation_fields =
      (Enum.find(definitions, fn obj -> obj.identifier === :mutation end) || %{fields: []})
      |> Map.get(:fields)

    other_fields =
      Enum.filter(definitions, fn obj -> not Enum.member?([:mutation, :query], obj.identifier) end)

    type_definitions = combine_types(schema_def.type_definitions, :query, query_fields)
    type_definitions = combine_types(type_definitions, :mutation, mutation_fields)

    blueprint =
      attrs
      |> List.insert_at(1, %{schema_def | type_definitions: type_definitions})
      |> Kernel.++([{:sdl, other_fields}, :close])
      |> Absinthe.Blueprint.Schema.build()

    pipeline =
      __MODULE__
      |> Absinthe.Pipeline.for_schema(
        prototype_schema: prototype_schema,
        persistent_term_name: __MODULE__
      )
      |> Absinthe.Schema.apply_modifiers(__MODULE__)

    blueprint
    |> Absinthe.Pipeline.run(pipeline)
  end
  import_types RehoboamGraphQl.Schema.EntryMutations
  import_types RehoboamGraphQl.Schema.EntryQueries
  import_types RehoboamGraphQl.Schema.EntryTypes
end
