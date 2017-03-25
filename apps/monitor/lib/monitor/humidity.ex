defmodule Monitor.Humidity do
  use GenServer

  import Logger

  @temp_overlay "/sys/bus/iio/devices/iio:device0/in_humidityrelative_input"
  @interval 60 * 1000 / 2 # half minute

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_args) do
    IO.puts("Humidity monitor init. Interval " <> "#{@interval}")

    send(self(), :refresh)
    {:ok, %{
          humidity: 0,
      }}
  end

  def get_value() do
    GenServer.call(__MODULE__, :get_value)
  end

  def handle_info(:refresh, state) do
    state = case File.read(@temp_overlay) do
       {:ok, value} ->

         {value, _} =
           String.strip(value)
           |> Integer.parse()

          value = value / 256 / 100 # sometimes first few are already celcius?
         value = :math.sqrt(value) * 10 # humidity calibration workaround...
         data = %HumiditySeries{}
         data = %{ data | fields: %{ data.fields | value: value }}
         data |> Monitor.InfluxConnection.write()
         Process.send_after(self(), :refresh, 30000)
         Logger.debug "Read Humidity: #{inspect value}"
         %{state | humidity: value}

       {:error, str} ->
         Process.send_after(self(), :refresh, 1000)
         Logger.debug "Error reading Humidity: #{inspect str}"
         state
      end
    {:noreply, state}
  end

  def handle_call(:get_value, _from, state) do
    {:reply, state.humidity, state}
  end

end
