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

defmodule TwitterBot.Analyzer do
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
  def processTweets(server, tweets) do
    GenServer.cast(server, {:processTweets, tweets})
  end
  
  ## Server Callbacks

  def init(0) do
    {:ok, 0}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
  
  def handle_cast({:processTweets, tweets}, requests) do
    tweets |>
      Enum.map(fn(t) -> TwitterBot.Tweet.extractGraphInfo(t) end) |>
      Enum.map(fn(edges) -> GenServer.cast(:GraphExportServer, {:exportCSV, edges}) end) 
    {:noreply, requests + 1}
  end

end
