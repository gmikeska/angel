require "angel/version"
require "angel/safe_query"
require "angel/default_icons"
require "angel/railtie"
# require "angel/models"
# require "angel/controllers"
# require "angel/components"
require "active_support/dependencies/autoload"

module Angel
  extend ActiveSupport::Autoload

  autoload_at "angel/models" do
    autoload :Base
    autoload :Design
    autoload :Page
  end

  autoload :Controllers
  autoload :Components
  @@base_model = ActiveRecord::Base


  def self.set_base_model(model)
    @@base_model = model
  end

  def self.base_model
    return @@base_model
  end
end
