class Page < Angel::Page
  include SupportsPointer
  if(!!ApplicationRecord && !!ApplicationRecord.pointers && ApplicationRecord.pointers.keys.include?(:model))
    uses_pointer(:model, from:ApplicationRecord)
  else
    parses_pointer :model
    pointer_resolution :model do |data|
      data[:model_name].classify.constantize
    end
  end

  if(!!ApplicationRecord && !!ApplicationRecord.pointers && ApplicationRecord.pointers.keys.include?(:model_instance))
    uses_pointer(:model_instance, from:ApplicationRecord)
  else
    parses_pointer :model_instance
    pointer_resolution :model_instance do |data|
      resolve_model_pointer(data[:model_name]).find(data[:param])
    end
  end
end
