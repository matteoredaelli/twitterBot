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

defmodule TwitterBot do
  use Application
  
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, [words_string]) do
    import Supervisor.Spec, warn: false
    words = String.split(words_string, ",")
    tasks_children = Enum.map(words,
      fn(w) -> worker(Task, [fn -> TwitterBot.TwitterStream.stream(w) end],
[restart: :permanent, id: w]) end)
    children = [
      # Define workers and child supervisors to be supervised
      worker(TwitterBot.TwitterServer, [:ok, [name: :TwitterServer]], restart: :permanent),
      worker(TwitterBot.DatabaseServer, [:ok, [name: :DatabaseServer]], restart: :permanent)
    ] ++ tasks_children

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
end
