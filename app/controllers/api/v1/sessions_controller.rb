class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: sessions_params[:email])

    if user&.valid_password?(sessions_params[:password])
      sign_in user, store: false
      user.generate_auth_token!
      user.save
      render json: user, status: 200
    else
      render json: {errors: 'invalid password or email'}, status: 401
    end
  end

  private

  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end
