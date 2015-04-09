Promise = require("promise")
Http = require("http")
Https = require("https")

###
  API calling module
###
module.exports = class Fetch

  constructor: () ->

  encodeToParams: (data) ->
    return Object.keys(data).map (k) ->
      return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
    .join('&')

  get: (opts = { }) ->
    opts.type = opts.type || "json"
    opts.body = opts.body || { }
    throw new Error("Field not specified: url") if not opts.url?

    return new Promise (fulfill) =>
      req = Http.get "#{opts.url}?#{@encodeToParams(opts.body)}", (res) ->
        res.on "data", (buffer) ->
          if opts.type is "json"
            data = JSON.parse(buffer)
          else
            data = buffer

          fulfill(data)
      req.end(null)

  gets: (opts = { }) ->
    opts.type = opts.type || "json"
    opts.body = opts.body || { }
    throw new Error("Field not specified: url") if not opts.url?

  post: () ->

  posts: () ->