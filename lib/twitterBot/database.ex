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

use Amnesia

# defines a database called Database, it's basically a defmodule with
# some additional magic
defdatabase Database do

  deftable User

  deftable UserUrl, [:user_id, :url], type: :bag do
    # this isn't required, but it's always nice to spec things
    @type t :: %UserUrl{user_id: integer, url: String.t}

    # this defines a helper function to fetch the user from a Message record
    def user(self) do
      User.read(self.user_id)
    end

    # this does the same, but uses dirty operations
    def user!(self) do
      User.read!(self.user_id)
    end
  end
  
  deftable UserHashtag, [:user_id, :hashtag], type: :bag do
    # this isn't required, but it's always nice to spec things
    @type t :: %UserHashtag{user_id: integer, hashtag: String.t}

    # this defines a helper function to fetch the user from a Message record
    def user(self) do
      User.read(self.user_id)
    end

    # this does the same, but uses dirty operations
    def user!(self) do
      User.read!(self.user_id)
    end
  end
  
  deftable UserMention, [:user_id, :mention], type: :bag do
    # this isn't required, but it's always nice to spec things
    @type t :: %UserMention{user_id: integer, mention: String.t}

    # this defines a helper function to fetch the user from a Message record
    def user(self) do
      User.read(self.user_id)
    end

    # this does the same, but uses dirty operations
    def user!(self) do
      User.read!(self.user_id)
    end
  end
    
  deftable User, [:id, :user], type: :ordered_set do
    # again not needed, but nice to have
    @type t :: %User{id: integer, user: String.t}

    ## hashtags

    def add_hashtag(self, hashtag) do
      %UserHashtag{user_id: self.id, hashtag: hashtag} |> UserHashtag.write
    end

    # like above, but again with dirty operations, the bang methods are used
    # thorough amnesia to be the dirty counterparts of the bang-less functions
    def add_hashtag!(self, hashtag) do
      %UserHashtag{user_id: self.id, hashtag: hashtag} |> UserHashtag.write!
    end

    # this is a helper to fetch all urls for the user
    def hashtags(self) do
      UserHashtags.read(self.id)
    end

    # like above, but with dirty operations
    def hashtags!(self) do
      UserHashtags.read!(self.id)
    end
    
    ##  urls
    
    def add_url(self, url) do
      %UserUrl{user_id: self.id, url: url} |> UserUrl.write
    end

    # like above, but again with dirty operations, the bang methods are used
    # thorough amnesia to be the dirty counterparts of the bang-less functions
    def add_url!(self, url) do
      %UserUrl{user_id: self.id, url: url} |> UserUrl.write!
    end

    # this is a helper to fetch all urls for the user
    def urls(self) do
      UserUrl.read(self.id)
    end

    # like above, but with dirty operations
    def urls!(self) do
      UserUrl.read!(self.id)
    end

    ##  mentions
    
    def add_mention(self, mention) do
      %UserMention{user_id: self.id, mention: mention} |> UserMention.write
    end

    # like above, but again with dirty operations, the bang methods are used
    # thorough amnesia to be the dirty counterparts of the bang-less functions
    def add_mention!(self, mention) do
      %UserMention{user_id: self.id, mention: mention} |> UserMention.write!
    end

    # this is a helper to fetch all mentions for the user
    def mentions(self) do
      UserMention.read(self.id)
    end

    # like above, but with dirty operations
    def mentions!(self) do
      UserMention.read!(self.id)
    end
    
  end
  
  deftable Hashtags, [:name, :top_hashtags], type: :ordered_set  do
    ## again not needed, but nice to have
    @type t :: %Hashtags{name: String.t,
                         top_hashtags: String.t}
    
  end
end
