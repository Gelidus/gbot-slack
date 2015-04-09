
###
  Pomodoro plugin
###
module.exports = class Pomodoro

  constructor: () ->
    @pomodoros = { }

  schedule: (name, time, cb) =>
    do (name, time, cb) =>
      pomodoro = setTimeout () =>
        cb(name, time)
      , time * 1000

      @pomodoros[name] = pomodoro

  unschedule: (name) ->
    clearTimeout(@pomodoros[name]) if @pomodoros[name]?