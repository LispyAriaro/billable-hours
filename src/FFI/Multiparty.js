'use strict';

var multiparty = require('multiparty');
var fs = require('fs');

exports.grabUploadData = function (req) {
  return function (fieldName) {
    return function() {
      return new Promise(function(resolve, reject) {
        try {
          var form = new multiparty.Form();

          form.parse(req, function(err, fields, files) {
            if(fields) {
              if(files && files[fieldName] && !fs.lstatSync(files[fieldName][0].path).isDirectory()) {
                console.log("files[fieldName][0]: ", files[fieldName][0]);

                fs.readFile(files[fieldName][0].path, 'utf8', function(err, contents) {
                  resolve(contents);
                });
              } else {
                reject("Sorry, you did not select any file!");
              }
            }
          });
        } catch (e) {
          var errorMsg = "Sorry, uploading the file failed!";
          reject(errorMsg);
        }
      }).catch(function() {
        var errorMsg = "Sorry, uploading the image failed 2!";
        return {status: 'failed', error: errorMsg};
      });
    }
  }
}
