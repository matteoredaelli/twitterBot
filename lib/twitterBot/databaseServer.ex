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
 
  def getHashtags(server, user) do
    GenServer.call(server, {:getHashtags, user})
  end
  
  def insertHashtags(server, user, hashtags) do
    GenServer.cast(server, {:insertHashtags, user, hashtags})
    end
  ## Server Callbacks
  
  def init(:ok) do
    Amnesia.start
    {:ok, %{}}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_call({:getHashtags, user}, _from, state) do
    user = Amnesia.transaction do
      Hashtags.read(user)
    end
    {:reply, user, state}
  end
  
  def handle_cast({:insertHashtags, user, hashtags}, state) do
    Amnesia.transaction do
      %Hashtags{name: user, top_hashtags: hashtags} |> Hashtags.write
    end
    {:noreply, state}
  end
  
end
