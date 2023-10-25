require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  before do 
    @user1 = User.create(name: "User One", email: "user1@test.com", password: 'password')
    i = 1
    20.times do 
      Movie.create(title: "Movie #{i} Title", rating: rand(1..10), description: "This is a description about Movie #{i}")
      i+=1
    end 
  end 

  it 'shows all movies' do
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test", password_confirmation: "test")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    visit "/users/#{user.id}"
    
    click_button "Find Top Rated Movies"

    expect(current_path).to eq("/users/#{user.id}/movies")

    expect(page).to have_content("Top Rated Movies")

    Movie.all.each do |movie|
      within("#movie-#{movie.id}") do 
        expect(page).to have_link(movie.title)
        expect(page).to have_content("Rating: #{movie.rating}/10")
      end 
    end 
  end 
end