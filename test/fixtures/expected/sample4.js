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
});

});