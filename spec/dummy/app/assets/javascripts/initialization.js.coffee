# application namespace
window.app ||= {}

app.apply_content_load_js = ($context) ->
  $context ||= $("body")

  (new app.CsvImportsTable("table.csv-imports", 5000)).start_reloading()
