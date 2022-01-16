defmodule Rehoboam.Utils.Text do
  def camelize(s) when is_binary(s) do
    Macro.camelize(s)
    |> String.split_at(1)
    |> then(fn {head, tail} ->
      String.downcase(head) <> tail
    end)
  end
  def camelize(s), do: s
end
