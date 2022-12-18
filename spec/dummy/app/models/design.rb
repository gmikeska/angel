class Design < Angel::Design
  include SupportsPointer
  belongs_to :page, optional: true


end
