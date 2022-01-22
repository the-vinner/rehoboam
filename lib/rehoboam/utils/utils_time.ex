defmodule Rehoboam.Utils.Time do
  @spec human_date(any()) :: {:ok, String.t() | nil} | {:error, String.t()}
  def human_date(d) do
    if is_date(d) do
      Timex.format(d, "{YYYY}-{0M}-{0D}")
    else
      {:error, "invalid_date"}
    end
  end

  @spec human_datetime(any()) :: {:ok, String.t() | nil} | {:error, String.t()}
  def human_datetime(d) do
    if is_date(d) do
      Timex.format(d, "{YYYY}-{0M}-{0D} @ {h24}:{m}")
    else
      {:error, "invalid_date"}
    end
  end

  def is_date(%DateTime{}), do: true
  def is_date(%NaiveDateTime{}), do: true
  def is_date(_), do: false
end
