require 'rails_helper'

RSpec.describe DeveloperApp do
    it "has a name" do
        developer_app = DeveloperApp.create!(name: "Best Developer App")
        expect(developer_app.name).to eq("Best Developer App")
    end

end