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

  convertBuffer: (buffer, to) ->
    if to is "json"
      return JSON.parse(buffer)
    else
      return buffer

  get: (opts = { }) =>
    opts.type = opts.type || "json"
    opts.body = opts.body || { }
    throw new Error("Field not specified: url") if not opts.url?

    return new Promise (fulfill) =>
      Http.get "#{opts.url}?#{@encodeToParams(opts.body)}", (res) =>
        res.on "data", (buffer) =>
          fulfill(@convertBuffer(buffer, opts.type))
      .end(null)

  gets: (opts = { }) =>
    opts.type = opts.type || "json"
    opts.body = opts.body || { }
    throw new Error("Field not specified: url") if not opts.url?

    return new Promise (fulfill) =>
      Https.get "#{opts.url}?#{@encodeToParams(opts.body)}", (res) =>
        res.on "data", (buffer) =>
          fulfill(@convertBuffer(buffer, opts.type))
      .end(null)

  post: () ->

  posts: () ->