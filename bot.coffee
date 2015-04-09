Robot = require("./src/robot")

bot = new Robot(require("./config"))

bot.when "hello", (data) -> # type of hello message
  console.log "Authenticated with server"

bot.command ["kto", "je", "pan"], (args, data) ->
  bot.sendTo data.channel, { text: "Ty si pan!" }

bot.command ["ping"] , (args, data) ->
  bot.sendTo data.channel, { text: "pong" }

bot.command ["shutdown"], (args, data) ->
  bot.sendTo data.channel, { text: "Bye bye" }
  bot.stop()

bot.run()