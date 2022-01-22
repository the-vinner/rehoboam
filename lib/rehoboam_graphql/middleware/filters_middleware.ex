defmodule RehoboamGraphQl.Middleware.Filters do
  @behaviour Absinthe.Middleware

  def call(%{context: ctx} = res, args) do
    %{
      res
      | context: %{
          ctx
          | filters: Map.merge(ctx.filters, args)
        }
    }
  end
end
