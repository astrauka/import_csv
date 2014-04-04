require "draper"
require "decent_exposure"

module ImportCsv
  class Engine < ::Rails::Engine
    # migrate together with application migrations
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded

        ActiveRecord::Tasks::DatabaseTasks.migrations_paths ||= []
        ActiveRecord::Tasks::DatabaseTasks.migrations_paths.concat(config.paths["db/migrate"].expanded)
      end
    end
  end
end
