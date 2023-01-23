class User < ApplicationRecord
  has_many :articles, foreign_key: 'author_id'
  serialize :options_data
  include Angel::DesignSettingsMethods

  after_initialize do |user|
    if(!user.options_data)
      user.options_data = {}
      user.save
    end
  end

  def design_settings(design_key=nil)
    if(!!options_data[design_key])
      data = options_data[design_key]
      if(data.is_a?(Hash))
        return data.symbolize_keys
      else
        return data
      end
    else
      return {}
    end

  end

  def set_design_settings(design_key, data)
    options_data[design_key] = data
    save()
  end
end
