defmodule RehoboamGraphQl.Resolver do
  def localize(key) do
    fn el, _, %{context: %Potionx.Context.Service{locale: locale, locale_default: locale_default}} ->
      {
        :ok,
        Map.get(el, key)
        |> Map.get(to_string(locale || locale_default))
      }
    end
  end
end
