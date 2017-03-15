defmodule Server.PageController do
  use Server.Web, :controller

  def index(conn, _params) do
    temp = Monitor.Temperature.get_temp()

    render conn, "index.html", temp: temp
  end
end
