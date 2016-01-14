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

defmodule TwitterBot.TwitterServer do
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
  
  def keys(server) do
    GenServer.call(server, {:keys})
  end
    
  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def processUser(server, name) do
    GenServer.cast(server, {:getTimeline, name})
  end

  def showHashtags(server, name) do
    GenServer.call(server, {:showHashtags, name})
  end
  
  def updateStatus(server, text) do
    GenServer.cast(server, {:updateStatus, text})
  end
  
  ## Server Callbacks

  def init(0) do
    {:ok, 0}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
  
  def handle_cast({:processUser, name}, requests) do
    hashtag_record = GenServer.call(:DatabaseServer, {:getHashtags, name})
    if is_nil(hashtag_record) do
      Logger.info "User #{name} NOT in the database: getting timeline"
      timeline = ExTwitter.user_timeline(screen_name: name, count: 500)
      if Enum.count(timeline) >= 20 do
        hashtags = TwitterBot.Tweets.extractHashtags(timeline)
        top_hashtags = TwitterBot.Utils.frequencies_without_counts(hashtags, 5)
        if Enum.count(top_hashtags) >= 1 do
          top_string = Enum.join(top_hashtags, " ")
          GenServer.cast(:DatabaseServer, {:insertHashtags, name, top_string})
          msg = "Top hashtags for @#{name}: #{top_string} http://www.redaelli.org/matteo-blog/projects/ebottwitter/"
          Logger.info IO.puts msg
          #ExTwitter.update(msg)
        else
          Logger.info "Too few hashtags for User #{name}: skipping hashtags"
        end
      else
        Logger.info "Too few records for User #{name}: skipping hashtags"
      end
    else
      Logger.info "User #{name} already in the database"
    end
    {:noreply, requests + 1}
  end
  
  def handle_cast({:updateStatus, text}, requests) do
    IO.puts text
    {:noreply, requests}
  end
  
end
