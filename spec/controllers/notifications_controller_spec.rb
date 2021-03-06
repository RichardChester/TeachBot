require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do

  before :each do
    @notification = create(:notification)
  end

  describe 'DELETE #destroy' do
    it 'returns Ok if all is valid' do
      auth_as(@notification.user)
      delete_request
      expect(response).to have_http_status(:success)
      expect(response.body).to match(/Ok/)
    end

    it 'redirects if user is not auth' do
      delete_request
      expect(response).to have_http_status(:redirect)
    end

    it 'returns 404 if notification not found' do
      auth_as(@notification.user)
      delete :destroy, params: { id: @notification.id + 1}
      expect(response).to have_http_status(:not_found)
      expect(response.body).to match(/Notification not found/)
    end
  end



  private
  def delete_request
    delete :destroy, params: { id: @notification.id}
  end

end
