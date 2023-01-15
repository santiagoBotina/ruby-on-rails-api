require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Test validations' do
    it 'should validate required fields'do
      should validate_presence_of(:email)
      should validate_presence_of(:name)
      should validate_presence_of(:auth_token)
    end

    it 'should validate relation' do
      should have_many(:posts)
    end
  end
end
