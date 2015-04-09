Robot = require("./src/robot")

bot = new Robot(require("./config"))

bot.when "hello", (data) -> # type of hello message
  console.log "Authenticated with server"

bot.command ["kto", "je", "pan"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Ty si pan!" }

bot.command ["ping"] , (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "pong" }

bot.command ["shutdown"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Bye bye" }
  bot.stop()

bot.run()