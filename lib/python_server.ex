defmodule ElixirPython.PythonServer do 
    use GenServer
    alias ElixirPython.Python
 
    def start_link(handlerName) do 
      GenServer.start_link(__MODULE__, [], name: :"#{handlerName}")
    end
 
    def init(args) do
      #Создаём сессии
      {:ok, python_session} = :python.start([{:python_path, './priv/python/'}])
      {:ok, python_session2} = :python.start([{:python_path, './priv/python/'}])
      #Регистрируем хендлеры
      Python.call(python_session, :test, :register_handler, [self()])
      Python.call(python_session2, :test2, :register_handler, [self()])
      IO.puts "Elixir time:"
      IO.inspect Time.utc_now
      #Высылаем test2 пид test
      Python.cast(python_session2, python_session)
      {:ok, python_session}
    end
 
    def handle_call({:count, count}, from, session) do 
       result = Python.call(session, :test, :long_counter, [count])
       {:reply, result, session}
    end
 
    def handle_cast({:count, count}, session) do 
      Python.cast(session, count)
      {:noreply, session}
    end
 
    def handle_info({:python, message}, session) do 
      IO.puts "Elixir time:"        
      IO.inspect Time.utc_now
      IO.puts "Received message from python: #{inspect message}"
      send(:Elixir2, {:handle, "FromElixir1"})
      {:noreply, session}
      #stop elixir process
      #{:stop, :normal,  session}
    end
 
    def terminate(_reason, session) do 
      Python.stop(session)
      :ok
    end
 
 end