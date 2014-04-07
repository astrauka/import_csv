class ImportCsvGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../spec/dummy/app', __FILE__)
  argument :model_to_import, type: :string, default: "Company"
  argument :controller_namespace_input, type: :string, default: ""
  argument :javascript_namespace, type: :string, default: ""
  class_option :skeleton,
               type: :boolean,
               default: true,
               desc: "Do not regenerate skeleton, only the model"

  # skeleton - builds skeleton, should be run only once
  def generate_initializer
    for_skeleton do
      copy_file "../config/initializers/import_csv.rb",
                "config/initializers/import_csv.rb"
    end
  end

  def generate_assets
    for_skeleton do
      copy_file "assets/javascripts/common/csv_imports_table.js.coffee",
                namespaced("app/assets/javascripts", javascript_namespace, "csv_imports_table.js.coffee")
    end
  end

  def generate_helpers
    for_skeleton do
      generated_file_name = "app/helpers/csv_imports_helper.rb"

      copy_file "helpers/csv_imports_helper.rb", generated_file_name
      add_namespace_to_module generated_file_name, controller_namespace
    end
  end

  def generate_skeleton_controllers
    for_skeleton do
      controllers = %w(base import_errors objects)

      controllers.each do |controller|
        controller_name = to_controller_name(controller)
        generated_file_name = namespaced("app/controllers",
                                         controller_namespace,
                                         "import_via_csv",
                                         controller_name)

        copy_file "controllers/import_via_csv/#{controller_name}", generated_file_name
        add_namespace_to_module generated_file_name, controller_namespace
      end
    end
  end

  def generate_skeleton_views
    for_skeleton do
      %w(import_errors objects).each do |view_dir|
        destination_dir = namespaced("app/views", controller_namespace, "import_via_csv", view_dir)
        directory "views/import_via_csv/#{view_dir}", destination_dir
      end
    end
  end

  def generate_decorators
    for_skeleton do
      directory "decorators", "app/decorators"
    end
  end

  def add_namespace_to_path_helpers
    for_skeleton do
      add_namespace_to_controllers_paths
      add_namespace_to_views_paths
      add_namespace_to_decorator_paths
    end
  end

  # concrete model

  def generate_strategy
    destination_file_name = "app/strategies/build_for_csv_import/#{model_file_name}.rb"

    copy_file "strategies/build_for_csv_import/#{example_model_name.underscore}.rb",
              destination_file_name
    replace_model_name destination_file_name
  end

  def generate_model
    destination_file_name = "app/models/csv_imports/#{model_file_name}.rb"

    copy_file "models/csv_imports/#{example_model_name.underscore}.rb",
              destination_file_name
    replace_model_name destination_file_name
  end

  def generate_controllers
    # model controller
    destination_file_name = namespaced "app/controllers",
                                       controller_namespace,
                                       "import_via_csv",
                                       to_controller_name(model_plural_file_name)

    copy_file "controllers/import_via_csv/#{to_controller_name(example_model_name.underscore.pluralize)}",
              destination_file_name
    add_namespace_to_module destination_file_name, controller_namespace
    replace_model_name destination_file_name
    add_namespace_to_paths destination_file_name
  end

  def generate_views
    # model view
    view_dir = example_model_name.underscore.pluralize
    destination_dir = namespaced("app/views", controller_namespace, "import_via_csv", model_plural_file_name)
    destination_file_name = File.join(destination_dir, "import_form.html.slim")

    directory "views/import_via_csv/#{view_dir}", destination_dir

    replace_model_name destination_file_name
    add_namespace_to_paths destination_file_name
  end

  def generate_csv_example_file
    copy_file "../public/downloads/example.csv",
              "public/downloads/#{model_plural_file_name}_sample.csv"
  end

  # routes change information must be displayed last
  def inform_user_about_skeleton_routes
    for_skeleton do
      puts %Q{
Please update your routes with the following

}
      if controller_namespace.present?
        puts "# inside namespace :#{controller_namespace}"
      end

      puts %Q{
  concern :importable do
    collection {
      get :import_form
      post :import
    }
  end

  namespace :import_via_csv, module: "import_via_csv", path: "import_via_csv" do
    resources :#{model_plural_file_name}, only: [] do
      concerns :importable
    end

    resources :objects, only: [:index, :show] do
      resources :import_errors, only: [:index]
    end
  end
}
    end
  end

  # routes change information must be displayed last
  def inform_user_about_routes
    unless options.skeleton?
      puts %Q{
Please update your routes with the following

  # inside namespace :import_via_csv"
    resources :#{model_plural_file_name}, only: [] do
      concerns :importable
    end
}
    end
  end

  private
  def namespaced(*paths)
    File.join paths.reject(&:blank?).map(&:underscore)
  end

  def controller_namespace
    if controller_namespace_input == "none"
      ""
    else
      controller_namespace_input
    end
  end

  def add_namespace_to_module(file, namespace)
    if namespace.present?
      gsub_file file,
                / ImportViaCsv/,
                " #{namespace.camelize}::ImportViaCsv"
    end
  end

  def model
    model_to_import.camelize
  end

  def model_plural
    model.pluralize
  end

  def model_file_name
    model_to_import.underscore
  end

  def model_plural_file_name
    model_file_name.pluralize
  end

  def example_model_name
    "Company"
  end

  def replace_model_name(file)
    gsub_file file,
              /#{example_model_name}/,
              model

    gsub_file file,
              /#{example_model_name.pluralize}/,
              model_plural

    gsub_file file,
              /#{example_model_name.underscore}/,
              model_file_name

    gsub_file file,
              /#{example_model_name.underscore.pluralize}/,
              model_plural_file_name
  end

  def add_namespace_to_paths(file)
    if controller_namespace.present?
      gsub_file file,
                /import_via_csv_/,
                "#{controller_namespace}_import_via_csv_"
    end
  end

  def to_controller_name(controller)
    "#{controller}_controller.rb"
  end

  def for_skeleton
    yield if options.skeleton?
  end

  def add_namespace_to_path_helpers_for(directory, file_extension)
    if controller_namespace
      Dir[File.join(destination_root, directory, "**/*.#{file_extension}")].each do |file|
        add_namespace_to_paths file
      end
    end
  end

  def add_namespace_to_controllers_paths
    dir = namespaced "app/controllers", controller_namespace, "import_via_csv"
    add_namespace_to_path_helpers_for dir, "rb"
  end

  def add_namespace_to_views_paths
    dir = namespaced "app/views", controller_namespace, "import_via_csv"
    add_namespace_to_path_helpers_for dir, "slim"
  end

  def add_namespace_to_decorator_paths
    dir = "app/decorators/import_via_csv"
    add_namespace_to_path_helpers_for dir, "rb"
  end
end
