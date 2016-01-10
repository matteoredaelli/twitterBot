# TwitterBot

**A simple Twitter Bot written in Elixir

## License
TwitterBot is free software under le license GNU v3+
http://www.gnu.org/licenses/

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add twitterBot to your list of dependencies in `mix.exs`:

        def deps do
          [{:twitterBot, "~> 0.0.1"}]
        end

  2. Ensure twitterBot is started before your application:

        def application do
          [applications: [:twitterBot]]
        end

## setup

  iex -S mix install

## run

  mix run -e 'TwitterBot.main "opensource"'
  elixir --detached -S mix run -e 'TwitterBot.main "opensource"'
