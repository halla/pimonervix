defmodule Monitor.Temperature do
  use GenServer

  import Logger

  @temp_overlay "/sys/bus/iio/devices/iio:device0/in_temp_input"

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_args) do
    IO.puts("Temperture monitor init.")
    {:ok, %{
          temp: -273,
      }}
  end

  def get_temp() do

    GenServer.call(__MODULE__, :get_temp)
  end


  def handle_call(:get_temp, _from, state) do
    newState = case File.read(@temp_overlay) do
       {:ok, temp} ->

         {temp, _} =
           String.strip(temp)
           |> Integer.parse()

          temp = temp / 256 / 100 # sometimes first few are already celcius?            

         Logger.debug "Read Temp: #{inspect temp}"
         %{state | temp: temp}

       {:error, str} ->
         Logger.debug "Error reading Temp: #{inspect str}"
         state
      end

    {:reply, state.temp, newState}
  end

end
