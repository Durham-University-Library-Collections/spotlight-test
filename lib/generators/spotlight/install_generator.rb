require 'rails/generators'

module Spotlight
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def inject_spotlight_routes
      route "mount Spotlight::Engine, at: 'spotlight'"
    end

    def assets
      copy_file "spotlight.css.scss", "app/assets/stylesheets/spotlight.css.scss"
      copy_file "spotlight.js", "app/assets/javascripts/spotlight.js"
    end
  end
end