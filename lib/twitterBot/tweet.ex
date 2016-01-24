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

defmodule TwitterBot.Tweet do
  @doc """
  Extract hashtags
  """
  def extractHashtags(tweet) do
    Enum.map(tweet.entities.hashtags, fn(x) -> x.text end)
  end
    
  @doc """
  Extract User mentions
  """
  def extractUserMentions(tweet) do
    Enum.map(tweet.entities.user_mentions, fn(x) -> x.id end)
  end

  @spec extractUrls(ExTwitter.Model.Tweet.t) :: [ String.t ]
  def extractUrls(tweet) do
    tweet
    |> Map.get(:entities)
    |> Map.get(:urls)
    |> Enum.map(&Map.get(&1, :expanded_url))
  end

end
