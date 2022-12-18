# frozen_string_literal: true
require_relative "table_component"
module Angel
  module Components
    class FilteredTableComponent < TableComponent
      attr_accessor :filters
      def initialize(**args)
        super
        self.data_controller = "filtered-table-component" #self.data("controller".to_sym => "filtered-table-component")
        @filters = args[:fields]
      end

      def options_for_filter
        options_for_select(super.keys.map{|k| [k,k] })
      end
    end
  end
end
