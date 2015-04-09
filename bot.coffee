Robot = require("./src/robot")

bot = new Robot {
  token: "xoxb-4375379199-ff0rNwJvo0xcOrD4DfYp8i8D"
  prefix: "$"
}

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