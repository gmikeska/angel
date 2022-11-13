module Angel
  class Group < Base
    has_many :designs
    belongs_to :page
    

  end
end
