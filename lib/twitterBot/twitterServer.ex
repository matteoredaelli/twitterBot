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
  def processTweet(server, user) do
    GenServer.cast(server, {:processUser, user})
  end
  
  def processUser(server, user) do
    GenServer.cast(server, {:processUser, user})
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

  def handle_cast({:processTweet, tweet}, requests) do
    ## sample id=2243653404
    ## timeline = ExTwitter.user_timeline(screen_name: "ebot70")
    ## user=List.first(timeline).user
    Logger.info "Processing tweet #{tweet.text} from user #{tweet.user.screen_name} (#{tweet.user.id}) ..."
    #GenServer.cast(:ElasticServer, {:addTweet, tweet.id, tweet})
    #GenServer.cast(:ElasticServer, {:addUser, tweet.user.id, tweet.user})
    {:noreply, requests + 1}
  end
  
  def handle_cast({:processUser, user}, requests) do
    ## sample id=2243653404
    ## timeline = ExTwitter.user_timeline(screen_name: "ebot70")
    ## user=List.first(timeline).user
    Logger.info "Processing user #{user.screen_name} (#{user.id}) ..."
    
    if is_nil(GenServer.call(:DatabaseServer, {:getUser, user.id})) do
      Logger.info "  User #{user.screen_name} (#{user.id}) NOT in the database: getting timeline"
      timeline = ExTwitter.user_timeline(id: user.id, count: 500)
      GenServer.cast(:TopInfoPublisher, {:processTimeline, timeline, user})
      GenServer.cast(:Analyzer, {:processTweets, timeline})
      :timer.sleep(4000)
      if is_nil(GenServer.call(:DatabaseServer, {:getUser, user.id})) do
        Logger.debug "  User #{user.screen_name} (#{user.id}) should be already in the database"
      else
        Logger.debug "  User #{user.screen_name} (#{user.id}) correctly saved in the database"
      end
    else
      Logger.info "  User #{user.screen_name} #{user.id} already in the database"
    end
    {:noreply, requests + 1}
  end
  
  def handle_cast({:updateStatus, text}, requests) do
    IO.puts text
    {:noreply, requests}
  end
  
end
