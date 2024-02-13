# PCBU Health and Safety web application

## API server

Node.js/Express API server with MongoDB database.

Database operations use [Mongoose](http://mongoosejs.com/).

[JSON Web Tokens](http://jwt.io/) are used for user authentication.

Tested with Node.js v0.12

### Configuration

API server configuration is managed by [node-config](https://github.com/lorenwest/node-config).
Configuration files must be in `api/config`.
A default configuration is in [api/config/default.coffee](api/config/default.coffee).
Only the default configuration file should be checked in to this repository.

### Initial user setup

A command line application is included to create the initial admin user.
Run `node create-initial-admin.js {username} {first name} {last name} {password}` from the `api` directory.
This will only create a user if an admin user does not already exist.


## Web client

AngularJS v1 single-page web application.

Javascript source is written in Coffeescript and packaged with Browserify.

### Development setup

Build tasks and most application dependencies are managed with NPM.

Run `npm i --dev` from the `client` directory to install package dependencies.

Tested with Node.js v0.12

### Build tasks

[Gulp](http://gulpjs.com/) task runner is used for build tasks.
Gulp should be installed globally with `npm i -g gulp`.

Tasks should be run from the `client` directory.

Tasks are defined in the `client/gulp/tasks` directory.

`gulp build` to compile for development.

`gulp production:build` to compile for production. Production build does not include sourcemaps.

`gulp watch` to continuously build during development and use BrowserSync to syncronise web browser.

`gulp revision` to runs `production:build` then hash revisions assets into clean `wwwRevisioned` directory.