module Angel
  module Components
    Dir[__dir__+"/components/*.rb"].each{|p| require p}
  end
end
