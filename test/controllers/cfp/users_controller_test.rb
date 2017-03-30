require 'test_helper'

class Cfp::UsersControllerTest < ActionController::TestCase
  setup do
    @call_for_participation = create(:call_for_participation)
    @conference = @call_for_participation.conference
  end

  test 'shows registration form' do
    get :new, params: { conference_acronym: @conference.acronym }
    assert_response :success
  end

  test 'allows registration of new user' do
    assert_difference 'User.count' do
      post :create, params: { conference_acronym: @conference.acronym, user: { email: 'new_user@example.com', password: 'frab123', password_confirmation: 'frab123' } }
    end
    assert_response :redirect
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user).confirmation_token
  end

  test 'shows password editing form' do
    login_as(:submitter)
    get :edit, params: { conference_acronym: @conference.acronym }
    assert_response :success
  end

  test 'allows editing of password' do
    login_as(:submitter)
    put :update, params: { conference_acronym: @conference.acronym, user: { password: '123frab', password_confirmation: '123frab' } }
    assert_response :redirect
  end
end
