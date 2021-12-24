defmodule RehoboamGraphQl.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers

  def handle_string_date(key, type \\ :naive) do
    fn
      el, _, _ ->
        val = Map.get(el, key)

        cond do
          is_binary(val) and type === :naive ->
            NaiveDateTime.from_iso8601(val)

          is_binary(val) ->
            DateTime.from_iso8601(val)

          true ->
            {:ok, val}
        end
    end
  end

  node object(:user) do
    field :bio, :string
    field :deleted_at, :datetime, resolve: handle_string_date(:deleted_at, :datetime)
    field :email, :string
    field :file, :file, resolve: dataloader(RehoboamGraphQl.Resolver.User)

    field :initials, :string do
      resolve(fn
        %{name_first: "", name_last: ""} = el, _, _ ->
          {:ok, String.slice(el.email, 0..2)}

        %{name_first: f, name_last: l} = el, _, _ when not is_nil(f) and not is_nil(l) ->
          {
            :ok,
            String.slice(el.name_first, 0..0) <> String.slice(el.name_last, 0..0)
          }

        el, _, _ ->
          {:ok, String.slice(el.email, 0..2)}
      end)
    end

    field :internal_id, :id,
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent || %{}, :id)}
      end

    field :inserted_at, :naive_datetime, resolve: handle_string_date(:inserted_at, :naive)
    field :name_first, :string

    field :name_full, :string do
      resolve(fn
        %{name_first: f, name_last: l}, _, _ when not is_nil(f) and not is_nil(l) ->
          {:ok, Enum.join([f, l], " ")}

        _, _, _ ->
          {:ok, ""}
      end)
    end

    field :name_last, :string
    field :roles, list_of(:string)
    field :slug, :string

    field :title, :string, resolve: Potionx.Resolvers.resolve_computed(Rehoboam.Users.User, :title)
    field :updated_at, :naive_datetime, resolve: handle_string_date(:updated_at, :naive)

    field :user_identities, list_of(:user_identity),
      resolve: dataloader(RehoboamGraphQl.Resolver.User)
  end

  node object(:user_public) do
    field :bio, :string
    field :file, :file, resolve: dataloader(RehoboamGraphQl.Resolver.User)

    field :internal_id, :id,
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent || %{}, :id)}
      end

    field :initials, :string do
      resolve(fn
        %{name_first: "", name_last: "", email: email}, _, _ ->
          {:ok, String.slice(email, 0..1)}

        %{name_first: f, name_last: l} = el, _, _ when not is_nil(f) and not is_nil(l) ->
          {
            :ok,
            String.slice(el.name_first, 0..0) <> String.slice(el.name_last, 0..0)
          }

        %{email: email}, _, _ ->
          {:ok, String.slice(email, 0..1)}
      end)
    end

    field :name_first, :string

    field :name_full, :string do
      resolve(fn
        %{name_first: f, name_last: l}, _, _ when not is_nil(f) and not is_nil(l) ->
          {:ok, Enum.join([f, l], " ")}

        _, _, _ ->
          {:ok, ""}
      end)
    end

    field :name_last, :string
    field :slug, :string
    field :title, :string, resolve: Potionx.Resolvers.resolve_computed(Rehoboam.Users.User, :title)
  end

  connection node_type: :user do
    field :count, non_null(:integer)
    field :count_before, non_null(:integer)

    edge do
    end
  end

  connection node_type: :user_public do
    field :count, non_null(:integer)
    field :count_before, non_null(:integer)

    edge do
    end
  end

  input_object :user_filters do
    field :deleted_at, :datetime
    # field :email, :string
    field :inserted_at, :naive_datetime
    field :name_first, :string
    field :name_last, :string
    field :roles, list_of(:string)
    field :slug, :string
    field :updated_at, :naive_datetime
  end

  input_object :user_input do
    field :bio, :string
    field :deleted_at, :datetime
    field :file, :upload
    field :inserted_at, :naive_datetime
    field :name_first, :string
    field :name_last, :string
    field :roles, list_of(:string)
    field :slug, :string
    field :updated_at, :naive_datetime
  end

  input_object :user_public_input do
    field :bio, :string
    field :file, :upload
    field :name_first, :string
    field :name_last, :string
    field :slug, :string
  end

  input_object :user_filters_single do
    field :id, :global_id
    field :slug, :string
  end

  object :user_mutation_result do
    field :errors, list_of(:string)
    field :errors_fields, list_of(:error)
    field :node, :user
    field :success_msg, :string
  end

end
