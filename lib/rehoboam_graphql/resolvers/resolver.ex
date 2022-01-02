defmodule RehoboamGraphQl.Resolver do
  def localize(key) do
    fn el, _, %{context: %Potionx.Context.Service{locale: locale, locale_default: locale_default}} ->
      {
        :ok,
        Map.get(el, key)
        |> case do
          val when is_map(val) ->
            Map.get(val, to_string(locale || locale_default))
          other -> other
        end
      }
    end
  end
end
