require "angel/version"
require "angel/railtie"
require "angel/models"
require "active_support/dependencies/autoload"

module Angel
  @@base_model = ActiveRecord::Base
  extend ActiveSupport::Autoload
  autoload :Components
  autoload :Helpers
  autoload :Controllers
  autoload :Design
  autoload :Group
  autoload :Page

  def self.set_base_model(model)
    @@base_model = model
  end

  def self.base_model
    return @@base_model
  end
end
