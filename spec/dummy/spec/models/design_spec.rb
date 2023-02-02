require 'rails_helper'

RSpec.describe Design, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:design) { FactoryBot.create(:design) }

  context("With a user settings scope") do
    before(:each) do
      design.settings_scope(:user, user)
    end
    it "returns the settings scope object for user" do
      expect(design.settings_scopes[:user].class.name).to eq("Angel::Options")
    end
    it "has defaults for the user scope" do
      expect(design.defaults[:user]).to eq({
        hidden_fields:{
          type:"Group(check_box)",
          title:"Field Visibility",
          value: {
            hide_name:false,
            hide_email:false,
            hide_articles_count:false
          }
        }
      })
      expect(design.settings_scopes[:user].defaults).to eq(design.defaults[:user])
    end
    it "returns settings for a settings scope with defaults" do
      expect(design.defaults[:user]).to eq({
        hidden_fields:{
          type:"Group(check_box)",
          title:"Field Visibility",
          value: {
            hide_name:false,
            hide_email:false,
            hide_articles_count:false
          }
        }
      })
      expect(design.settings_scopes[:user].settings).to eq(design.defaults[:user])
    end
    it "returns a single setting from the users scope" do
      user_scope = design.settings_scopes[:user]
      expect(user_scope[:hidden_fields]).to eq({
        type:"Group(check_box)",
        title:"Field Visibility",
        value: {
          hide_name:false,
          hide_email:false,
          hide_articles_count:false
        }
      })
    end
    it "updates user scope when settings are updated" do
      user_scope = design.settings_scopes[:user]
      user_scope[:hidden_fields] = {
        type:"Group(check_box)",
        title:"Field Visibility",
        value: {
          hide_name:false,
          hide_email:true,
          hide_articles_count:false
        }
      }
      expect(design.settings_scopes[:user].settings).to eq({
        hidden_fields:{
          type:"Group(check_box)",
          title:"Field Visibility",
          value: {
            hide_name:false,
            hide_email:true,
            hide_articles_count:false
          }
        }
      })
    end
  end
end
