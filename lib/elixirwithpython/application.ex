defmodule Elixirwithpython.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  import Supervisor.Spec, warn: true


  use Application

  def start(_type, _args) do
    children = [
      worker(Elixirwithpython, ["Elixir2"]),
      worker(ElixirPython.PythonServer, ["Elixir1"])
      # Starts a worker by calling: Elixirwithpython.Worker.start_link(arg)
      # {Elixirwithpython.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixirwithpython.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
