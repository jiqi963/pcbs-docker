mongoose = require 'mongoose'

CertificationSchema = mongoose.Schema {
  name:
    type: String
    required: true

  business:
    type: mongoose.Schema.Types.ObjectId
    ref: 'business'
    required: true

  classification:
    type: String
    enum: ['person', 'equipment', 'material', 'vehicle']
    required: true

  person:
    nameFirst: String
    nameLast: String
    position: String

  equipment:
    description: String

  material:
    description: String

  vehicle:
    make: String
    model: String
    registration: String

  date:
    type: Date
    required: true

  expiryDate:
    type: Date
    required: true
}

module.exports = mongoose.model 'Certification', CertificationSchema
