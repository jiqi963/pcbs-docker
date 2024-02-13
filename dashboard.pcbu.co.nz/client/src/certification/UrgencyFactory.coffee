moment = require 'moment'

daysDue = 28
daysDueSoon = 90

futureDue = moment().add(daysDue, 'days').endOf 'day'
futureDueSoon = moment().add(daysDueSoon, 'days').endOf 'day'

module.exports = () ->
  obj = {
    daysDue: daysDue
    daysDueSoon: daysDueSoon

    isDue: (d) ->
      d? and moment(d).isBefore futureDue

    isDueSoon: (d) ->
      d? and moment(d).isBetween futureDue, futureDueSoon

    getClass: (d, suffix = '') ->
      out = {}

      suffix = '-' + suffix if suffix

      if d?
        switch
          when obj.isDue d
            out['is-due' + suffix] = true
          when obj.isDueSoon d
            out['is-due-soon' + suffix] = true
          else out['is-not-due' + suffix] = true

      out

    getOrder: (due, dueSoon) ->
      n = 0
      n -= (due or 0) * 2
      n -= dueSoon or 0
      n
  }

  obj
