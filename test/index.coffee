assert      = require 'assert'
trans       = require '../'

describe 'translate', ->

  describe 'Translate en -> zh-CN ', ->
    it "Hello world", (done) ->
      trans("Hello world", "en", "zh-CN", (error, ret) ->
        assert.ifError(error)
        assert.equal(ret, '你好世界')
        done()
      )

    it '你好世界', (done) ->
      trans("你好世界", "zh-CN", "en", (error, ret) ->
        assert.ifError(error)
        assert.equal(ret, 'Hello world')
        done()
      )
