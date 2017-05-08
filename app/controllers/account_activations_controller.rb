# handle account activation requests
class AccountActivationsController < ApplicationController
  before_action :check_interval_presence, only: [:create]
  before_action :require_guest, only: [:new]

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success_notice] = 'Account activated!'
    else
      flash[:danger_notice] = 'Invalid activation link'
    end
    redirect_to root_url
  end

  # Form to create activation code
  def new; end

  # Create activation code
  def create
    @user = User.find_by(email: params[:user][:email])
    @user.resend_activation_email if @user
    render json: {}
  end

  private

  def check_interval_presence
    Services::Throttle::RequestInterval.new(self, time: 15)
  rescue StandardError => e
    fail_response([e.message + ' Try in 15 seconds'], 403)
  end
end
