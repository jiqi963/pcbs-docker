mongoose = require 'mongoose'

ContactSchema = mongoose.Schema {
  nameFirst:
    type: String
    required: true

  nameLast:
    type: String
    required: true

  position: String

  phone: String

  mobile: String

  email: String
}

BusinessSchema = mongoose.Schema {
  name:
    type: String
    required: true

  description: String

  serviceStartDate:
    type: Date
    required: true

  serviceLevel:
    type: Number
    required: true

  streetAddress: String

  locality:
    name: String
    region: String

  industry:
    type: [String]

  contactPcbu: [ContactSchema]

  contactOfficer: [ContactSchema]

  clientId:
    type: Number

  isClientEditable: Boolean
}

module.exports = mongoose.model 'Business', BusinessSchema
