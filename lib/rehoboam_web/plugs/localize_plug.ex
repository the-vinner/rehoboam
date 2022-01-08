defmodule Rehoboam.Plugs.Localize do
  @behaviour Plug

  def init(opts), do: opts

  def call(%{assigns: %{context: ctx}} = conn, _) do
    [default_locale | _] = Rehoboam.Localization.Locale.defaults()

    Plug.Conn.assign(conn, :context, %{
      ctx
      | locale: default_locale.locale,
        locale_default: default_locale.locale
    })
  end
end
