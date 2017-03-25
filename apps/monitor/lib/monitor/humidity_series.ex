defmodule HumiditySeries do
  use Instream.Series

  series do
    database    "pimonervix"
    measurement "humidity"

    tag :bar
    tag :foo

    field :value
  end
end
