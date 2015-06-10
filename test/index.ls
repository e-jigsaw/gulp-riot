require! {
  \power-assert : assert
  \gulp-util : gutil
}

riot = unless process.env.CI is \true then require \../src/ else require \../build/

it 'should compile riot tag file', (callback)->
  stream = riot!

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal contents, """
      riot.tag('sample', '<p>test { sample }</p>', function(opts) {

        this.sample = 'hoge'

      });
    """
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>

        this.sample = 'hoge'
      </sample>
    '''
    path: '/hoge/fuga.tag'

  stream.end!

it 'should use compile options', (callback)->
  stream = riot do
    compact: true

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal contents, """
      riot.tag('sample', '<p>test { sample }</p><p>test { sample }</p><p>test { sample }</p>', function(opts) {

        this.sample = 'hoge'

      });
    """
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>
        <p>test { sample }</p>
        <p>test { sample }</p>

        this.sample = 'hoge'
      </sample>
    '''
    path: '/hoge/fuga.tag'

  stream.end!

it 'should jade extension rename js', (callback)->
  stream = riot!

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal file.path, \/hoge/fuga.js
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>
        this.sample = 'hoge'
      </sample>
    '''
    path: '/hoge/fuga.jade'

  stream.end!

it 'should match cli output when type: none', (callback)->
  stream = riot do
    type: \none

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal contents, """
      riot.tag('sample', '<p>test { sample }</p>', function(opts) {
        sample() {
          console.log('test')
        }

      });
    """
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>
        sample() {
          console.log('test')
        }
      </sample>
    '''
    path: '/hoge/fuga.tag'

  stream.end!
