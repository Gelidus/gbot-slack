Robot = require("./src/robot")

bot = new Robot(require("./config"))

bot.plugin(require("./plugins/fetch"))
bot.plugin(require("./plugins/pomodoro"))
bot.plugin(require("./plugins/ciphers"))
bot.plugin(require("./plugins/simpledb"))

http = require("http")

bot.when "hello", (data) -> # type of hello message
  console.log "Running."

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

  bot.use("Fetch").get({
    url: "http://api.openweathermap.org/data/2.5/weather"
    body: {
      q: args[0]
    }
  }).then (weather) ->
    if weather.cod is "404"
      bot.send channel, { text: "Can't find information about given city!" }
    else
      bot.send channel, { text: "Weather in #{args[0]}: #{weather.weather[0].description}, temp: #{Math.round((weather.main.temp - 272.15)*100)/100}C , wind: #{weather.wind.speed}" }

bot.command ["pomodoro"], (args, data) ->
  return if args.length < 2
  channel = bot.getChannel(data.channel)

  bot.use("Pomodoro").schedule args[0], args[1], (name, total) ->
    bot.send channel, { text: "Pomodoro time! [#{name}]" }

  bot.send channel, { text: "Pomodoro [#{args[0]}] registered" }

bot.command ["cipher", "encrypt"], (args, data) ->
  return if args.length < 2
  channel = bot.getChannel(data.channel)

  bot.use("Ciphers").encrypt args[0], args[1], (cipher) ->
    bot.send(channel, { text: "Encrypted message [#{cipher}]"})

bot.command ["cipher", "decrypt"], (args, data) ->
  return if args.length < 2
  channel = bot.getChannel(data.channel)

  bot.use("Ciphers").decrypt args[0], args[1], (text) ->
    bot.send(channel, { text: "Decrypted message [#{text}]" })

bot.command ["db"], (args, data) ->
  return if args.length < 1
  channel = bot.getChannel(data.channel)

  bot.use("Simpledb").execute data.text.slice(data.text.indexOf(" ") + 1), (err, rows) ->
    if err?
      bot.send(channel, {text: "Error happened: #{err.toString()}"})
    else
      console.dir rows
      if rows?
        bot.send(channel, {text: JSON.stringify(rows, null, 4)})
      else
        bot.send(channel, {text: "Query done!"})

bot.command ["help"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Halp yourzelf" }

bot.command ["shutdown"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Bye bye" }
  bot.sleep()

bot.command ["wakeup"], (args, data) ->
  channel = bot.getChannel(data.channel)

  bot.send channel, { text: "Hello again" }
  bot.wakeup()

bot.persistCommand("wakeup")
bot.run()
