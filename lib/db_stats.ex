defmodule Mix.Tasks.DbStats do
  use Mix.Task
  use Database
   
  def run(_) do
    Amnesia.Schema.create

    Amnesia.start

    IO.puts "User: #{User.count}, UserHashtag: #{UserHashtag.count}, UserMention: #{UserMention.count}, UserUrl: #{UserUrl.count}"
    # Stop mnesia so it can flush everything and keep the data sane.
    #Amnesia.info
    Amnesia.stop
  end
end
