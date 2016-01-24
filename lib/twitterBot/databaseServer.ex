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

defmodule TwitterBot.DatabaseServer do
  use GenServer
  use Database
  
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

  def addUserHashtags(server, userid, hashtags) do
    GenServer.cast(server, {:addUserHashtags, userid, hashtags})
  end
  
  def addUserMentions(server, userid, mentions) do
    GenServer.cast(server, {:addUserMentionss, userid, mentions})
  end

  def addUserUrls(server, userid, urls) do
    GenServer.cast(server, {:addUserUrls, userid, urls})
  end

  def getUser(server, id) do
    GenServer.call(server, {:getUser, id})
  end
  ## Server Callbacks
  
  def init(:ok) do
    Amnesia.start
    {:ok, %{}}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_call({:getUser, id}, _from, state) do
    u = Amnesia.transaction do
      User.read(id)
    end
    {:reply, u, state}
  end
  
  def handle_cast({:addUser, id, user}, state) do
    Amnesia.transaction do
      %User{id: id, user: user} |> User.write
    end
    {:noreply, state}
  end
  
  def handle_cast({:addUserHashtags, userid, hashtags}, state) do
    Amnesia.transaction do
      u = User.read(userid)
      Enum.map(hashtags, fn(x) -> u |> User.add_hashtag(x) end)
    end
    {:noreply, state}
  end
  
  def handle_cast({:addUserMentions, userid, mentions}, state) do
    Amnesia.transaction do
      u = User.read(userid)
      Enum.map(mentions, fn(x) -> u |> User.add_mention(x) end)
    end
    {:noreply, state}
  end
  
  def handle_cast({:addUserUrls, userid, urls}, state) do
    Amnesia.transaction do
      u = User.read(userid)
      Enum.map(urls, fn(x) -> u |> User.add_url(x) end)
    end
    {:noreply, state}
  end
end
