'use strict';


exports.sendResponse = function(res) {
  return function(payload) {
    return function() {
      return res.json(payload);
    }
  }
}

exports.sendResponseWithStatus = function(res) {
  return function(statusCode) {
    return function(payload) {
      return function() {
        return res.status(statusCode).json(payload);
      }
    }
  }
}
