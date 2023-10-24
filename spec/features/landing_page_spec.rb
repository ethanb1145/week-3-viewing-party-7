require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: "password")
    user2 = User.create(name: "User Two", email: "user2@test.com", password: "password")
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: "password")
    user2 = User.create(name: "User Two", email: "user2@test.com", password: "password")

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
    end     
  end

  it 'has a link to Log In that should log the user in; happy path' do 
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test", password_confirmation: "test")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(root_path)

    expect(page).to have_content("Welcome, #{user.name}")
  end

  it 'should not log the user in if input is invalid credentials; sad path' do 
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test", password_confirmation: "test")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: 'incorrect_password'

    click_on "Log In"

    expect(current_path).to_not eq(root_path)

    expect(page).to_not have_content("Welcome, #{user.name}")
    expect(page).to have_content("Sorry, your credentials are bad.")
  end
end
