# application namespace
window.app ||= {}

app.apply_content_load_js = ($context) ->
  $context ||= $("body")

