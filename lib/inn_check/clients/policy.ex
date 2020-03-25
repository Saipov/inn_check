defmodule InnCheck.Clients.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:view_client, user, _client), do: user.roles.admin
end
