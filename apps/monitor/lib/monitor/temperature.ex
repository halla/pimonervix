defmodule Monitor.Temperature do
  use GenServer

  import Logger

  @temp_overlay "/sys/bus/iio/devices/iio:device0/in_temp_input"
  @interval 60 * 1000 / 2 # half minute

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_args) do
    IO.puts("Temperture monitor init. Interval " <> "#{@interval}")

    send(self(), :refresh)
    {:ok, %{
          temp: -273,
      }}
  end

  def get_temp() do

    GenServer.call(__MODULE__, :get_temp)
  end

  defp read_temp() do

  end

  def handle_info(:refresh, state) do
    state = case File.read(@temp_overlay) do
       {:ok, temp} ->

         {temp, _} =
           String.strip(temp)
           |> Integer.parse()

          temp = temp / 256 / 100 # sometimes first few are already celcius?
         data = %TempSeries{}
         data = %{ data | fields: %{ data.fields | value: temp }}
         data |> Monitor.InfluxConnection.write()
         Process.send_after(self(), :refresh, 30000)
         Logger.debug "Read Temp: #{inspect temp}"
         %{state | temp: temp}

       {:error, str} ->
         Process.send_after(self(), :refresh, 1000)
         Logger.debug "Error reading Temp: #{inspect str}"
         state
      end
    {:noreply, state}
  end

  def handle_call(:get_temp, _from, state) do
    {:reply, state.temp, state}
  end

end
