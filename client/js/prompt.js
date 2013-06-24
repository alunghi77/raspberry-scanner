var prompt = require('prompt'); // https://github.com/flatiron/prompt and https://github.com/qrpike/NodeJS-CLI-Listener
var request  = require('request');
var http = require('http');
var schema = {
    properties: {
                barcode: {
                        required: true,
                        hidden: true
                }
    }
};

prompt.start();

console.log('Barcode Scanner ready.....');

prompt.get(schema, function (err, result) {

    if (err) { console.log(err); return onErr(err); }

// An object of options to indicate where to post to
  var post_options = {
      host: 'scanner.dev',
      port: '8087',
      path: '/',
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
          'Content-Length': result.barcode.length
      }
  };

  // Set up the request
  var post_req = http.request(post_options, function(res) {
      res.setEncoding('utf8');
      res.on('data', function (chunk) {
          console.log('Response: ' + chunk);
      });
  });

  // post the data
  post_req.write(result.barcode);
  post_req.end();


 
    console.log('Barcode Scanner read:' + result.barcode);

});


function onErr(err) {
        console.log(err);
    return 1;
}