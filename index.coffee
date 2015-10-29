request = require 'request'

ec = encodeURIComponent

translateTask = (x) ->
  (item, callback) ->
    key = "name_#{item[0]}"
    return callback(null, [item[0], x[key]]) if x[key]
    async.retry({times: 5, interval: 5000}, (done) ->
      getWithCache1hour(item[1], done)
    , (error, ret) ->
      return callback(error) if error
      if _.isString(ret)
        v = (new Function("return #{ret}"))()[0][0][0]
      else
        v = ret[0][0][0]
      callback(null, [item[0], v])
    )

_callback = (callback) ->
  (error, res, body) ->
    return callback(Error("Net connect error")) if error
    return callback(Error("Service error: #{body}")) if res.statusCode >= 400
    if typeof body is 'string'
      v = (new Function("return #{body}"))()[0][0][0]
    else
      v = body[0][0][0]
    callback(null, v)

_url = (text, source, dest) ->
  "https://translate.google.com/translate_a/single?client=t&sl=#{source}&tl=#{dest}&hl=#{dest}&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&pc=1&otf=1&ssel=0&tsel=0&kc=1&tk=96009|481150&q=#{ec text}"

module.exports = (text, source, dest, callback) ->
  request.get(_url(text, source, dest), _callback(callback))
