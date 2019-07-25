'use strict';

var multiparty = require('multiparty');
var fs = require('fs');

exports.grabUploadData = function (req) {
  return function (fieldName) {
    new Promise(function(resolve, reject) {
      try {
        var form = new multiparty.Form();

        form.parse(req, function(err, fields, files) {
          if(fields) {
            console.log("files: ", files);
            console.log("files[fieldName][0]: ", files[fieldName][0]);

            if(files && !fs.lstatSync(files[fieldName][0].path).isDirectory()) {
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
    });
  }
}
