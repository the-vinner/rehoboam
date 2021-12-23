defmodule Rehoboam.Sessions.SessionService do
  use Potionx.Auth.SessionService,
    identity_service: Rehoboam.UserIdentities.UserIdentityService,
    repo: Rehoboam.Repo,
    session_schema: Rehoboam.Sessions.Session,
    user_schema: Rehoboam.Users.User,
    user_service: Rehoboam.Users.UserService
end
