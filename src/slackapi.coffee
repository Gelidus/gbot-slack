Promise = require("promise")

Https = require('https')

module.exports = class API

  constructor: (@options) ->

  getMeta: () =>
    return new Promise (fulfill) =>
      chunk = ""
      Https.get "https://slack.com/api/rtm.start?token=#{@options.token}", (res) ->
        res.on "data", (data) ->
          chunk += data
        res.on "end", () ->
          fulfill(JSON.parse(chunk))
      .end(null)