defmodule Jmunited.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Jmunited.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Jmunited.PubSub}
      # Start a worker by calling: Jmunited.Worker.start_link(arg)
      # {Jmunited.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Jmunited.Supervisor)
  end
end
