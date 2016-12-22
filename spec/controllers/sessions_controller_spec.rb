require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  before :each do
    create(:user)
  end

  it 'responds successfully if correct data' do
    post :create, params: {
        session: {
            email: 'testuser@gmail.com',
            password: 'password'
        }
    }

    expect(response).to have_http_status(302) # indicate redirect status code
  end

  it 'responds error status if user not found' do
    post :create, params: {
        session: {
            email: 'invalid@example.com',
            password: 'invalid'
        }
    }

    expect(response).to have_http_status(404)
  end
end