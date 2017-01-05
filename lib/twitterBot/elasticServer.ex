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

defmodule TwitterBot.ElasticServer do
  use GenServer
  require Logger
  import Tirexs.HTTP
  
 ## Client API
  
  @doc """
  Starts the registry.
  """
  def start_link(_, opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end
  
  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.call(server, :stop)
  end
  
  def addUser(server, id, user) do
    GenServer.cast(server, {:addUser, id, user})
  end

  def addTweet(server, id, tweet) do
    GenServer.cast(server, {:addTweet, id, tweet})
  end
  ## Server Callbacks
  
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
  
  def handle_cast({:addTweet, id, tweet}, state) do
    put("/grafo/twitter_tweet/" <> Integer.to_string(id), tweet)
    {:noreply, state}
  end
  
  def handle_cast({:addUser, id, user}, state) do
    put("/grafo/twitter_user/" <> Integer.to_string(id), user)
    {:noreply, state}
  end
end
