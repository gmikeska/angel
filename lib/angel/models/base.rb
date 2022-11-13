require "active_record/base"
module Angel
  class Base < ActiveRecord::Base
    self.abstract_class = true

    def settings
      return settings_data
    end
  end
end
