defmodule Mix.Tasks.Upgrade do
  use Mix.Task
  use Database
   
  def run(_) do
    Amnesia.Schema.create

    Amnesia.start

    Database.User.create
    Database.UserUrl.create
    Database.UserMention.create
    Database.UserHashtag.create
    
    Amnesia.stop
  end
end
