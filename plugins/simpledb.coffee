Promise = require("promise")
SQLite = require("sqlite3").verbose()

module.exports = class Simpledb

  constructor: () ->
    @database = new SQLite.Database("./data.db")

  destroy: () =>
    @database.close()

  execute: (query, callback) =>
    return if query.split(" ").length < 1

    console.log("Executing query: #{query}")

    if query.split(" ")[0] == "SELECT"
      @database.all query, (err, rows) ->
        callback(err, rows)
    else
      @database.run query, (err) ->
        callback(err, null)
