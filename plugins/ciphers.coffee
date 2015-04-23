
module.exports = class Ciphers

  constructor: () ->
    @ciphers = [
      "caesar"
    ]

  encrypt: (byCipher, what, callback) ->
    return callback("Cipher #{byCipher} not found") if byCipher not in @ciphers

    return callback(@[byCipher + "Encrypt"](what))

  decrypt: (byCipher, what, callback) ->
    return callback("Cipher #{byCipher} not found") if byCipher not in @ciphers

    return callback(@[byCipher + "Decrypt"](what))

  caesarEncrypt: (text, options = { }) ->
    options.offset = options.offset || 5

    encrypt = ""
    for n in text
      encrypt += String.fromCharCode(n.charCodeAt(0) + options.offset)

    return encrypt

  caesarDecrypt: (text, options = { }) ->
    options.offset = options.offset || 5

    decrypt = ""
    for n in text
      decrypt += String.fromCharCode(n.charCodeAt(0) - options.offset)

    return decrypt