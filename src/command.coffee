
module.exports = class Command

  constructor: (@options) ->
    throw new Error("Name of command not specified [name]") if not @options.name?

    @subcommands = { }
    @action = null

  register: (list, action) =>
    if list.length is 0 # found current command
      @action = action
      return

    name = list[0]
    list.shift()

    if not @subcommands[name]?
      @subcommands[name] = new Command {
        name: name
      }

    @subcommands[name].register(list, action)

  invoke: (args, data) =>
    if args.length is 0 or not @subcommands[args[0]]? and @action?
      return @action(args, data)

    if args.length > 0 and @subcommands[args[0]]?
      @subcommands[args.shift()].invoke(args, data)
    else
      console.log "Unrecognized command specified"