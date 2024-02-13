module.exports =
  server:
    port: 8080

  mongodb: 'mongodb://localhost/pcbu_dev'

  jsonWebToken:
    secret: 'secret'

  mysql:
    host: 'localhost'
    user: 'dashboard_user'
    password: 'a43b68d063'
    database: 'pcbu'

  joomla:
    clientTable: 'pcbu_users'
    sessionTable: 'pcbu_session'
