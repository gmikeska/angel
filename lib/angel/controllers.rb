module Angel
  module Controllers
    Dir[__dir__+"/controllers/*.rb"].each{|p| require p}
  end
end
