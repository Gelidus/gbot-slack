Promise = require("promise")
WebAPI = require("./slackapi")
Socket = require("ws")
Action = require("./action")
Command = require("./command")

module.exports = class Robot

  constructor: (@options) ->
    @options.prefix = @options.prefix || "$"

    @webapi = new WebAPI(@options)
    @socket = null
    @actions = { }
    @commands = { }

    @store = { }

  run: () =>
    @webapi.getMeta().then (meta) =>
      @initializeUsers(meta)

      @socket = new Socket(meta.url)
      @initializeSocket()

  initializeUsers: (meta) =>
    @store.users = { }
    @addUser(user) for user in meta.users

  addUser: (user) =>
    @store.users[user.name] = user

  getUser: (name) =>
    return @store.users[name]

  stop: () =>
    @socket.close()

  initializeSocket: () =>
    return if not @socket?

    @socket.on "open", @onOpen
    @socket.on "message", @onSocketMessage

  onOpen: () =>

  onSocketMessage: (buffer, flags) =>
    data = JSON.parse(buffer)
    event = data.type

    @actions[event].exec(data) if @actions[event]?

    if data.type is "message"
      @onMessage(data)

  onMessage:(data) =>
    if data.text.length > @options.prefix.length and data.text.substr(0, @options.prefix.length) is @options.prefix
      trueData = data.text.substr(@options.prefix.length)
      args = trueData.split(" ")

      return if args.length < 1 or not @commands[args[0]]?
      @commands[args.shift()].invoke(args, data)

  when: (event, action) =>
    if not @actions[event]?
      @actions[event] = new Action {
        robot: @
        event: event
      }

    @actions[event].add(action)

  command: (list, action) =>
    return if list.length < 0

    name = list.shift() # remove first element

    if not @commands[name]?
      @commands[name] = new Command {
        name: name
      }

    @commands[name].register(list, action)

  send: (data) =>
    data.token = data.token || @options.token

    @socket.send(JSON.stringify(data))

  sendTo: (channel, data) =>
    data.type = "message"
    data.token = data.token || @options.token
    data.channel = data.channel || channel

    @socket.send(JSON.stringify(data))