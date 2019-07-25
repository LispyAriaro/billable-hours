'use strict';

const K = require('knex');
var pg = require('pg');

var KnexFile = require('../../config/knexfile');
// console.log("KnexFile: ", KnexFile);

var knexDbConfigs = {};
knexDbConfigs['development'] = KnexFile['development'];
knexDbConfigs['production'] = KnexFile['production'];

var dbEnvVar = 'BillableHours_DbEnv';
var dbEnv = process.env[dbEnvVar] || 'development';
console.log(dbEnvVar + ": " + dbEnv + "\n");

var dbConfig = knexDbConfigs[dbEnv];
var knex = K(dbConfig);


exports.getAllQ = function (tableName) {
  knex(tableName).select('*').toString();
}

exports.getByQ = function (tableName) {
  return function (columnName) {
    return function (columnVal) {
      var queryObj = {};
      queryObj[columnName] = columnVal;

      return knex(tableName).where(queryObj).select('*').toString();
    }
  }
}

exports.getWhereQ = function (tableName) {
  return function (whereClauses) {
    if(whereClauses && whereClauses.length > 0) {
      var kObj = knex(tableName);

      whereClauses.forEach(function(clause) {
        kObj.where(
          clause.value0, // column name
          clause.value1, // comparison operator
          clause.value2  // value
        )
      });
      return kObj.select('*').toString();
    }
  }
}


// exports.getNotBy = function (tableName) {
//   return function (columnName) {
//     return function (columnVal) {
//       var queryObj = {};
//       queryObj[columnName] = columnVal;
//
//       return knex(tableName).where(queryObj).select('*').toString();
//     }
//   }
// }


exports.insertQ = function (insertObj) {
  return function (tableName) {
    return knex(tableName).insert(insertObj).returning('id').toString();
  }
}

exports.updateQ = function (updateObj) {
  return function (whereClauses) {
    return function (tableName) {
      if(whereClauses && whereClauses.length > 0) {
        var kObj = knex(tableName);

        whereClauses.forEach(function(clause) {
          kObj.where(
            clause.value0, // column name
            clause.value1, // comparison operator
            clause.value2  // value
          )
        });
        kObj.update(updateObj);

        return kObj.toString();
      }
    }
  }
}
