defmodule RehoboamGraphQl.Utils.Time do
  alias Rehoboam.Utils.Time

  @spec human_date_resolver(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def human_date_resolver(key) do
    fn el, _, _ ->
      Map.get(el, key)
      |> case do
        nil -> {:ok, nil}
        t -> Time.human_date(t)
      end
    end
  end

  @spec human_datetime_resolver(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def human_datetime_resolver(key) do
    fn el, _, _ ->
      Map.get(el, key)
      |> case do
        nil -> {:ok, nil}
        t -> Time.human_datetime(t)
      end
    end
  end
end
