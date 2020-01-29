defmodule Elixirwithpython do
  use GenServer
  alias ElixirPython.Python

  def start_link(handlerName) do 
     GenServer.start_link(__MODULE__, [], name: :"#{handlerName}")
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info({:handle, message}, state) do 
    IO.puts "Elixir time:"        
    IO.inspect Time.utc_now
    {:noreply, state}
  end
end