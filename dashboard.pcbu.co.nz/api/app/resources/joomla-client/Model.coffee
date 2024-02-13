config = require 'config'
mysql = require 'mysql'

mysqlConfig = config.get 'mysql'

mysqlPool = mysql.createPool mysqlConfig
escapedClientTable = mysql.escapeId config.get 'joomla.clientTable'
escapedSessionTable = mysql.escapeId config.get 'joomla.sessionTable'

console.log 'Created MySQL connection pool', mysqlConfig

dbQuery = (sql, callback) ->
  mysqlPool.getConnection (error, connection) ->
    if error
      console.error 'Connection to MySQL failed:', error.message
      return callback error

    console.log 'Connected to MySQL:', connection.threadId

    connection.query sql, [], (error, results) ->
      if error
        console.error 'MySQL query failed:', error.message
        console.error 'Failed query:', sql

      console.log 'Connection released to MySQL connection pool:', connection.threadId
      connection.release()
      callback error, results

module.exports =
  healthCheck: (callback) ->
    out = {}
    dbQuery "SELECT 'Connect to MySQL'", (error1) ->
      out['Connection'] = { error: error1 }
      dbQuery "SELECT 'Client table exists' FROM #{escapedClientTable}", (error2) ->
        out["#{escapedClientTable} table exists"] = { error: error2 }
        dbQuery "SELECT 'Session table exists' FROM #{escapedSessionTable}", (error3) ->
          out["#{escapedSessionTable} table exists"] = { error: error3 }
          callback(null, out)

  all: (callback) ->
    sql = "SELECT id, name, block = 0 AS active
          FROM #{escapedClientTable}"

    dbQuery sql, callback

  one: (id, callback) ->
    escapedId = mysql.escape id
    sql = "SELECT id, name, block = 0 AS active
          FROM #{escapedClientTable}
          WHERE id = #{escapedId}"

    dbQuery sql, (error, result) ->
      callback error, result[0]

  isLoggedIn: (id, sessionId, callback) ->
    escapedId = mysql.escape id
    escapedSessionId = mysql.escape sessionId
    sql = "SELECT session_id
          FROM #{escapedSessionTable}
          WHERE userid = #{escapedId}
          AND session_id = #{escapedSessionId}"

    dbQuery sql, (error, result) ->
      return callback error if error
      callback null, {
        id: parseInt id
        sessionId: sessionId
        isLoggedIn: result.length > 0
      }

  isActive: (id, callback) ->
    escapedId = mysql.escape id
    sql = "SELECT block = 0 AS active
          FROM #{escapedClientTable}
          WHERE id = #{escapedId}"

    dbQuery sql, (error, result) ->
      callback error, result[0]? and result[0].active isnt 0
