defmodule Mix.Tasks.Install do
  use Mix.Task
  use Database
   
  def run(_) do
    Amnesia.Schema.create

    Amnesia.start

    #Database.create!(ram: [node])
    Database.create!(disk: [node])

    # This waits for the database to be fully created.
    Database.wait

    # Stop mnesia so it can flush everything and keep the data sane.
    Amnesia.stop
  end
end
