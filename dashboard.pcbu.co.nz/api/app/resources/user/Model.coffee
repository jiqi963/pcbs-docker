mongoose = require 'mongoose'
bcrypt = require 'bcrypt-nodejs'

SALT_WORK_FACTOR = 10

UserSchema = mongoose.Schema {
  username:
    type: String
    required: true
    index:
      unique: true

  nameFirst:
    type: String
    required: true

  nameLast:
    type: String
    required: true

  password:
    type: String
    required: true

  isAdmin:
    type: Boolean
}

UserSchema.pre 'save', (next) ->
  user = this
  # only hash the password if it has been modified (or is new)
  return next() unless user.isModified 'password'

  # generate a salt
  bcrypt.genSalt SALT_WORK_FACTOR, (error, salt) ->
    return next error if error

    #  hash the password along with our new salt
    bcrypt.hash user.password, salt, null, (error, hash) ->
      return next error if error

      # override the cleartext password with the hashed one
      user.password = hash
      next()

UserSchema.methods.isValidPassword = (candidatePassword, callback) ->
  bcrypt.compare candidatePassword, @password, (error, isMatch) ->
    return callback error if error
    callback null, isMatch

UserSchema.methods.toJSON = () ->
  obj = @toObject()
  delete obj.password
  obj

module.exports = mongoose.model 'User', UserSchema
