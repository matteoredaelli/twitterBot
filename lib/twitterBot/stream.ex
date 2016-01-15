#    twitterBot, a simple twitter Bot written in Elixir
#    Copyright (C) 2016 Matteo.Redaelli@gmail.com
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

defmodule TwitterBot.TwitterStream do
  require Logger
  
  def stream(word) do
    # a tweet about starting ebottwitter
    timestamp = :os.system_time(:seconds)
    msg = "@ebot70: starting #twitterBot for word ##{word} at #{timestamp} http://www.redaelli.org/matteo-blog/projects/ebottwitter/"
    Logger.info msg
    
    #ExTwitter.update(msg)

    stream = ExTwitter.stream_filter(track: word)
    stream
    |> Stream.map(fn(x) -> GenServer.cast(:TwitterServer, {:processUser, x.user.screen_name}) end)
    |> Enum.to_list
  end
end
