defmodule RehoboamGraphQl.Middleware.MeLatest do
  @behaviour Absinthe.Middleware
  alias Rehoboam.Users.UserService

  def call(%{context: %Potionx.Context.Service{user: %{id: id}} = ctx} = res, _) do
    %{
      res
      | context: %{
          ctx
          | user:
              UserService.one(%Potionx.Context.Service{
                filters: %{
                  id: id
                }
              })
        }
    }
  end

  def call(res, _) do
    res
    |> Absinthe.Resolution.put_result({:ok, nil})
  end
end
