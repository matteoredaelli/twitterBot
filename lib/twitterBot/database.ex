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
  
  deftable Hashtags, [:name, :top_hashtags], type: :ordered_set  do
    ## again not needed, but nice to have
    @type t :: %Hashtags{name: String.t,
                         top_hashtags: String.t}
    
  end
end
