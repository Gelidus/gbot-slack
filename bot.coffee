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

bot.command ["help"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Halp yourzelf" }

bot.command ["shutdown"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Bye bye" }
  bot.stop()

bot.run()