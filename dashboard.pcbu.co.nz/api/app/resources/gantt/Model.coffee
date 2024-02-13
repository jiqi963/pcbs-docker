mongoose = require 'mongoose'

TaskSchema = mongoose.Schema {
  name: String
  from: Date
  to: Date
  color: String
}

RowSchema = mongoose.Schema {
  name: String
  tasks: [TaskSchema]
}

GanttSchema = mongoose.Schema {
  rows: [RowSchema]
}

module.exports = mongoose.model 'Gantt', GanttSchema
