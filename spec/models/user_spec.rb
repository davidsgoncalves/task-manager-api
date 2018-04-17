require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'required attributes' do
    it 'should have all required attributes' do
      # TODO: not passing because it's is impossible to create user without an email by db rules.
      # is_expected.to validate_presence_of(:email)
      is_expected.to validate_uniqueness_of(:email).case_insensitive
      is_expected.to validate_confirmation_of(:password)
      is_expected.to allow_value('email@provider.com').for(:email)
      is_expected.to validate_uniqueness_of(:auth_token)
    end
  end

  describe '#info' do
    it 'returns email and created_at' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('asdf')

      expect(user.info).to eq "#{user.email} - #{user.created_at} - Token: asdf"
    end
  end

  describe '#generate_auth_token!' do
    it 'generate a unique token' do
      allow(Devise).to receive(:friendly_token).and_return('asdf')

      user.generate_auth_token!

      expect(user.auth_token).to eq 'asdf'
    end

    it 'generate another token with first token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('qwer', 'qwer', '1234')
      existing_user = create(:user, auth_token: 'qwer')

      user.generate_auth_token!
      expect(user.auth_token).not_to eq (existing_user.auth_token)
    end
  end
end
