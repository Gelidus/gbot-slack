

module.exports = class Action

  constructor: (@options) ->
    throw new Error("Robot not specified [robot]") if not @options.robot?
    throw new Error("Event name not specified [event]") if not @options.event?
    @delegates = []

  add: (delegate) =>
    @delegates.push(delegate)

  remove: (delegate) =>
    @delegates.remove(@delegates.indexOf(delegate))

  exec: (data) =>
    delegate(data, @options.robot) for delegate in @delegates