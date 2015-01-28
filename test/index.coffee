assert = require 'power-assert'
gutil = require 'gulp-util'
riot = require '../src/'

it 'should compile riot tag file', (callback)->
  stream = riot()

  stream.once 'data', (file)->
    contents = file.contents.toString()
    assert.equal contents, """
      riot.tag('sample', '<p>test { sample }</p>', function(opts) {

        this.sample = 'hoge'

      });
    """
    callback()

  stream.write new gutil.File
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>

        this.sample = 'hoge'
      </sample>
    '''
    path: '/hoge/fuga.tag'

  stream.end()
