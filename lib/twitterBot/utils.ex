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

defmodule TwitterBot.Utils do
  
  @doc """
  Extract hashtags
  """
  def frequencies(words, n) do
    words |>
      Enum.reduce(Map.new, fn c,acc -> Dict.update(acc, c, 1, &(&1+1)) end) |>
      Enum.sort_by(fn {_k,v} -> -v end) |>
      Enum.take(n)               
  end

  def frequencies_without_counts(words, n) do
    frequencies(words, n) |>
      Enum.map(fn {k,_} -> k end)
  end
                       
end
