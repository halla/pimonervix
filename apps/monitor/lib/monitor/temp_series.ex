defmodule TempSeries do
  use Instream.Series

  series do
    database    "pimonervix"
    measurement "temperature"

    tag :bar
    tag :foo

    field :value
  end
end
