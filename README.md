# TwitterBot

A simple Twitter Bot written in Elixir

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

  1. Set the environment variables:
  
    TWITTER_STREAM_WORDS  ex. "opensource,linux,iot"
    TWITTER_CONSUMER_KEY
    TWITTER_CONSUMER_SECRET
    TWITTER_ACCESS_TOKEN
    TWITTER_ACCESS_SECRET
  
  2. create the database and tables with

    iex -S mix install

## run

 (old releases) 
  mix run -e 'TwitterBot.main "opensource"'
  elixir --detached -S mix run -e 'TwitterBot.main "opensource"'

  (latest releases)
  mix run --no-halt
  elixir --detached -S mix run --no-halt

