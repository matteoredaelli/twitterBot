defmodule TwitterBot.TwitterStream do
  def stream(word) do
    stream = ExTwitter.stream_filter(track: word)
    stream
    |> Stream.map(fn(x) -> GenServer.cast(:TwitterServer, {:processUser, x.user.screen_name}) end)
    |> Enum.to_list
  end
end
