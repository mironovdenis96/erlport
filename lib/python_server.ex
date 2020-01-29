defmodule ElixirPython.PythonServer do 
    use GenServer
    alias ElixirPython.Python
 
    def start_link() do 
       GenServer.start_link(__MODULE__, [])
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
 
    def cast_count(count) do 
       {:ok, pid} = start_link()
       #GenServer.cast(pid, {:count, count})
    end
 
    def call_count(count) do
       {:ok, pid} = start_link()
       # :infinity timeout only for demo purposes
       GenServer.call(pid, {:count, count}, :infinity)
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
       {:noreply, session}
       #stop elixir process
       #{:stop, :normal,  session}
    end
 
    def terminate(_reason, session) do 
      Python.stop(session)
      :ok
    end
 
 end