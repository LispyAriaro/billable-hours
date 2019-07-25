'use strict';

exports.runInsertQuery_ = function (queryStr) {
  return function (client) {
    return function (error, success) {
      client.query(queryStr, function (err, result) {
        if (err) {
          error(err);
        } else {
          success(result);
        }
      });
      return function (cancelError, onCancelerError, onCancelerSuccess) {
        onCancelerSuccess();
      };
    };
  };
}
