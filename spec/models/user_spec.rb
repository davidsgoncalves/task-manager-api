require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'required attributes' do
    it 'should have all required attributes' do
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_uniqueness_of(:email).case_insensitive
      is_expected.to validate_confirmation_of(:password)
      is_expected.to allow_value('email@provider.com').for(:email)
    end
  end
end
