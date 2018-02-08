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