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

defmodule TwitterBot.TopInfoPublisher do
  use GenServer
  require Logger
  
  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(_, opts) do
    GenServer.start_link(__MODULE__, 0, opts)
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.call(server, :stop)
  end
    
  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def processTimeline(server, timeline, user) do
    GenServer.cast(server, {:processTimeline, timeline, user})
  end
  
  ## Server Callbacks

  def init(0) do
    {:ok, 0}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
  
  def handle_cast({:processTimeline, timeline, user}, requests) do
    GenServer.cast(:DatabaseServer, {:addUser, user.id, user})
    hashtags = TwitterBot.Tweets.extractHashtags(timeline)
    top_hashtags = TwitterBot.Utils.frequencies_without_counts(hashtags, 5)
    top_string = Enum.join(top_hashtags, " ")
    msg = "Top hashtags for @#{user.screen_name}: #{top_string} http://www.redaelli.org/matteo-blog/projects/ebottwitter/"
    Logger.info msg
    if Enum.count(top_hashtags) > Application.get_env(:twitterBot, :showHashtagsIfMoreThen) and Application.get_env(:twitterBot, :updateStatus) do
      try do
        ExTwitter.update(msg)
      catch
        _error -> 
          ExTwitter.new_direct_message(user, msg)
      end
    else
      Logger.info ":updateStatus=false OR Too few hashtags for User @#{user.screen_name} #{user.id}: skipping hashtags"
    end

    {:noreply, requests + 1}
  end
  
  def handle_cast({:updateStatus, text}, requests) do
    IO.puts text
    {:noreply, requests}
  end
  
end
