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

defmodule TwitterBot.Tweets do
  
  @doc """
  Extract hashtags
  """
  def extractHashtags(tweets) do
    pipe = tweets |>
      Enum.map(fn(x) -> x.entities.hashtags end) |>
      Enum.filter(fn(x) -> Enum.count(x) > 0 end)  |>
      Enum.map(fn(x) -> Enum.map(x, fn(z) -> "#" <> String.downcase(z.text) end) end) |>
      Enum.map(fn(x) -> List.flatten(x) end)
    List.flatten(pipe)
  end
    
  @doc """
  Extract User mentions
  """
  def extractUserMentions(tweet) do
    Enum.map(tweet.entities.user_mentions, fn(x) -> x.screen_name end)
  end
                       
end
