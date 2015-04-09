Robot = require("./src/robot")

bot = new Robot(require("./config"))
bot.plugin(require("./plugins/pomodoro"))

http = require("http")

bot.when "hello", (data) -> # type of hello message
  console.log "Authenticated with server"

bot.command ["kto", "je", "pan"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Ty si pan!" }

bot.command ["ping"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "pong" }

bot.command ["joke"], (args, data) ->
  channel = bot.getChannel(data.channel)

  req = http.get "http://api.icndb.com/jokes/random", (res) ->
    res.on "data", (buffer) ->
      joke = JSON.parse(buffer)
      bot.send channel, { text: joke.value.joke }

  req.end()

bot.command ["weather"], (args, data) ->
  return if args.length < 1
  channel = bot.getChannel(data.channel)

  req = http.get "http://api.openweathermap.org/data/2.5/weather?q=#{args[0]}", (res) ->
    res.on "data", (buffer) ->
      weather = JSON.parse(buffer)
      if weather.cod is "404"
        bot.send channel, { text: "Can't find information about given city!" }
      else
        bot.send channel, { text: "Weather in #{args[0]}: #{weather.weather[0].description}, temp: #{Math.round(weather.main.temp/33.8*100)/100}C , wind: #{weather.wind.speed}" }

  req.end()

bot.command ["pomodoro"], (args, data) ->
  return if args.length < 2
  channel = bot.getChannel(data.channel)

  bot.use("Pomodoro").schedule args[0], args[1], (name, total) ->
    bot.send channel, { text: "Pomodoro time! [#{name}]" }

  bot.send channel, { text: "Pomodoro [#{args[0]}] registered" }

bot.command ["help"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Halp yourzelf" }

bot.command ["shutdown"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Bye bye" }
  bot.stop()

bot.run()