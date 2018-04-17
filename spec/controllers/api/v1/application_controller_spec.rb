require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'includes the correct concerns' do
    it 'should have Authenticable concern' do
      expect(controller.class.ancestors).to include(Authenticable)
    end
  end
end