# handle account activation requests
class AccountActivationsController < ApplicationController
  before_action :check_interval_presence, only: [:create]

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
    return error_message(['Email not found'], 404) unless @user
    return error_message([already_confirmed], 422) if @user.activated?
    @user.resend_activation_email
    send_activation_email_interval
  end

  private

  def send_activation_email_interval
    $redis_connection.set(activation_interval, true, ex: 15.minutes)
  end

  def check_interval_presence
    activation_interval_error if interval_exists?
  end

  def activation_interval_error
    error_message(['You can send another email once in 15 minutes'], 403)
  end

  def already_confirmed
    'Email has already been confirmed'
  end

  def interval_exists?
    $redis_connection.get(activation_interval).present?
  end

  def activation_interval
    "throttle[activation_email][#{request.remote_ip}]"
  end
end
