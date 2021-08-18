defmodule Jmunited.Repo do
  use Ecto.Repo,
    otp_app: :jmunited,
    adapter: Ecto.Adapters.MyXQL
end
