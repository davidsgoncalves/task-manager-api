require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }
  context 'users attributes' do
    it 'should respond to email' do
      expect(@user).to respond_to(:email)
    end

    it 'should responde to name' do
      expect(@user).to respond_to(:name)
    end

    it 'should responde to passwords and password_confirmation' do
      expect(@user).to respond_to(:password)
      expect(@user).to respond_to(:password_confirmation)
    end

    it 'should be valid' do
      expect(@user).to be_valid
    end
  end
end
