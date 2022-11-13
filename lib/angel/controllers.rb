module Angel
  module Components
    # require "angel_gui/components/customizable_component"
    # require "angel_gui/components/table_component"
    Dir["../../lib/angel/controllers/*.rb"].each{|p| require p}
    # binding.pry
  end
end
