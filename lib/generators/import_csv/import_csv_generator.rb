class ImportCsvGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../spec/dummy/app', __FILE__)
  argument :model_to_import, type: :string, default: "Company"
  argument :controller_namespace_input, type: :string, default: ""
  argument :javascript_namespace, type: :string, default: ""
  class_option :skeleton,
               type: :boolean,
               default: true,
               desc: "Do not regenerate skeleton, only the model"

  def generate_initializer
    for_skeleton do
      copy_file "../config/initializers/import_csv.rb",
                "config/initializers/import_csv.rb"
    end
  end

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

  def generate_assets
    for_skeleton do
      copy_file "assets/javascripts/common/csv_imports_table.js.coffee",
                namespaced("app/assets/javascripts", javascript_namespace, "csv_imports_table.js.coffee")
    end
  end

  def generate_helpers
    for_skeleton do
      generated_file_name = namespaced("app/helpers", controller_namespace, "csv_imports_helper.rb")

      copy_file "helpers/csv_imports_helper.rb", generated_file_name
      add_namespace_to_module generated_file_name, controller_namespace
    end
  end

  def generate_controllers
    for_skeleton do
      controllers = %w(base import_errors objects)

      controllers.each do |controller|
        controller_name = to_controller_name(controller)
        generated_file_name = namespaced("app/controllers",
                                         controller_namespace,
                                         "csv_imports",
                                         controller_name)

        copy_file "controllers/csv_imports/#{controller_name}", generated_file_name
        add_namespace_to_module generated_file_name, controller_namespace
      end
    end

    # model controller
    destination_file_name = namespaced "app/controllers",
                                       controller_namespace,
                                       "csv_imports",
                                       to_controller_name(model_plural_file_name)

    copy_file "controllers/csv_imports/#{to_controller_name(example_model_name.underscore.pluralize)}",
              destination_file_name
    add_namespace_to_module destination_file_name, controller_namespace
    replace_model_name destination_file_name
  end

  def generate_views
    for_skeleton do
      %w(import_errors objects).each do |view_dir|
        destination_dir = namespaced("app/views", controller_namespace, "csv_imports", view_dir)
        directory "views/csv_imports/#{view_dir}", destination_dir
      end
    end

    # model view
    view_dir = example_model_name.underscore.pluralize
    destination_dir = namespaced("app/views", controller_namespace, "csv_imports", model_plural_file_name)

    directory "views/csv_imports/#{view_dir}", destination_dir
    replace_model_name File.join(destination_dir, "import_form.html.slim")
  end

  def generate_decorators
    for_skeleton do
      directory "decorators", "app/decorators"
    end
  end

  def inform_user_about_routes
    if options.skeleton?
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

  namespace :csv_imports, module: "csv_imports", path: "csv_imports" do
    resources :#{model_plural_file_name}, only: [] do
      concerns :importable
    end

    resources :objects, only: [:index, :show] do
      resources :import_errors, only: [:index]
    end
  end
}
    else
      puts %Q{
Please update your routes with the following

  # inside namespace :csv_imports"
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
                /\Amodule /,
                "module #{namespace.camelize}::"
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

  def to_controller_name(controller)
    "#{controller}_controller.rb"
  end

  def for_skeleton
    yield if options.skeleton?
  end
end
