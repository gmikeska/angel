class User < ApplicationRecord
  has_many :articles, foreign_key: 'author_id'
  serialize :options_data

  after_initialize do |user|
    if(!user.options_data)
      user.options_data = {}
      user.save
    end
  end

  def component_options(key)
    if(!!options_data[key])
      data = options_data[key]
      if(data.is_a?(Hash))
        return data.symbolize_keys
      else
        return data
      end
    else
      return {}
    end

  end

  def set_component_options(key, data)
    options_data[key] = data
    save()
  end
end
