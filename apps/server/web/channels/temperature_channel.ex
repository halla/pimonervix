defmodule Server.TemperatureChannel do
  use Server.Web, :channel

  def join("temp:1", _params, socket) do
    :timer.send_interval(1000, :refresh)
    {:ok, socket}
  end


  def handle_info(:refresh, socket) do
    temp = Monitor.Temperature.get_temp
    broadcast! socket, "temp", %{temp: temp}
    {:noreply, socket}
  end
end
