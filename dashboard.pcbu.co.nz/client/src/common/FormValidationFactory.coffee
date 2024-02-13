module.exports = () ->
  (item = {}) ->
    {
      'has-error': item?.$invalid
    }
