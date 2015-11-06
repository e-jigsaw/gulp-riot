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
      riot.tag2('sample', '<p>test {sample}</p>', '', '', function(opts) {

        this.sample = 'hoge'
      }, '{ }');
    """
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>

        this.sample = 'hoge'
      </sample>
    '''
    path: \/hoge/fuga.tag

  stream.end!

it 'should use compile options', (callback)->
  stream =
    riot do
      compact: true

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal contents, """
      riot.tag2('sample', '<p>test {sample}</p><p>test {sample}</p><p>test {sample}</p>', '', '', function(opts) {

        this.sample = 'hoge'
      }, '{ }');
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
    path: \/hoge/fuga.tag

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
    path: \/hoge/fuga.jade

  stream.end!

it 'should match cli output when type: none', (callback)->
  stream =
    riot do
      type: \none

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal contents, """
      riot.tag2('sample', '<p>test {sample}</p>', '', '', function(opts) {
        sample() {
          console.log('test')
        }
      }, '{ }');
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
    path: \/hoge/fuga.tag

  stream.end!

it 'should match modular options output', (callback)->
  stream =
    riot do
      modular: true

  stream.once \data, (file)->
    contents = file.contents.toString!
    assert.equal contents, '''
      (function(tagger) {
        if (typeof define === 'function' && define.amd) {
          define(['riot'], function(riot) { tagger(riot); });
        } else if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {
          tagger(require('riot'));
        } else {
          tagger(window.riot);
        }
      })(function(riot) {
      // Login API
      var auth = riot.observable()

      auth.login = function(params) {
        $.get('/api', params, function(json) {
          auth.trigger('login', json)
        })
      }


      <!-- login view -->
      riot.tag2('login', '<form onsubmit="{login}"> <input name="username" type="text" placeholder="username"> <input name="password" type="password" placeholder="password"> </form>', '', '', function(opts) {

        this.login = function() {
          opts.login({
            username: this.username.value,
            password: this.password.value
          })
        }.bind(this)

        opts.on('login', function() {
          $(body).addClass('logged')
        })
      }, '{ }');

      });
    '''
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      // Login API
      var auth = riot.observable()

      auth.login = function(params) {
        $.get('/api', params, function(json) {
          auth.trigger('login', json)
        })
      }


      <!-- login view -->
      <login>
        <form onsubmit="{ login }">
          <input name="username" type="text" placeholder="username">
          <input name="password" type="password" placeholder="password">
        </form>

        login() {
          opts.login({
            username: this.username.value,
            password: this.password.value
          })
        }

        // any tag on the system can listen to login event
        opts.on('login', function() {
          $(body).addClass('logged')
        })
      </login>
    '''
    path: \/hoge/fuga.tag

  stream.end!

it 'should return error when compile failed', (callback)->
  stream =
    riot do
      type: \nonescript

  stream.once \error, (err)->
    assert.equal err.plugin, \gulp-riot
    callback!

  stream.write new gutil.File do
    contents: new Buffer '''
      <sample>
        <p>test { sample }</p>

        this.sample = 'hoge'
      </sample>
    '''
    path: \/hoge/fuga.tag

  stream.end!
