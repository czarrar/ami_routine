$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

String.prototype.format = function() { 
  s = this;
  if (arguments.length == 1 && arguments[0].constructor == Object) {
    for (var key in arguments[0]) {
      s = s.replace(new RegExp("\\{" + key + "\\}", "g"), arguments[0][key]);
    }
  } else {
    for (var i = 0; i < arguments.length; i++) {
      s = s.replace(new RegExp("\\{" + (i+1) + "\\}", "g"), arguments[i]);
    }
  }
  return s;
};