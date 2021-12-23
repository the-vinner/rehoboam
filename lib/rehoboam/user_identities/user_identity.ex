defmodule Rehoboam.UserIdentities.UserIdentity do
  use Ecto.Schema

  schema "user_identities" do
    field :provider, :string
    field :uid, :string
    belongs_to :user, Rehoboam.Users.User

    timestamps()
  end

  def changeset(struct, params) do
    Potionx.Auth.Identity.changeset(struct, params)
  end
end
