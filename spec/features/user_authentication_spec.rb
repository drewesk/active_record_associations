require 'rails_helper'

feature 'User Authentication' do
  scenario 'allows a user to signup' do
    visit '/'

    expect(page).to have_link('Signup')

    click_link 'Signup'

    fill_in 'First name', with: 'bob'
    fill_in 'Last name', with: 'smith'
    fill_in 'Email', with: 'bob@smith.com'
    fill_in 'Password', with: 'sup3rs3krit'
    fill_in 'Password confirmation', with: 'sup3rs3krit'

    click_button 'Signup'

    expect(page).to have_text('Thank you for signing up Bob')
    expect(page).to have_text('bob@smith.com')
  end

  scenario 'allows existing users to login' do
    user = FactoryGirl.create(:user)

    visit '/'

    expect(page).to have_link('Login')

    click_link('Login')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_text("Welcome back #{user.first_name.titleize}")
    expect(page).to have_text(user.email)
  end

  scenario 'does not allow existing users to login with an invalid password' do
    user = FactoryGirl.create(:user, password: 'Sup3rS3krit')

    visit '/'

    expect(page).to have_link('Login')

    click_link('Login')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'NOT_YOUR_PASSWORD'

    click_button 'Login'

    expect(page).to have_text('Invalid email or password')
  end

  scenario 'allows a logged in user to logout' do
    user = FactoryGirl.create(:user, password: 'Sup3rS3krit')

    visit '/'

    expect(page).to have_link('Login')

    click_link('Login')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_text(user.email)

    expect(page).to have_link('Logout')

    click_link('Logout')

    expect(page).to have_text("#{user.email} has been logged out")
    expect(page).to_not have_text("Welcome back #{user.first_name.titleize}")
    expect(page).to_not have_text("Signed in as #{user.email}")
  end

  scenario 'allow a logged in user to claim a car' do
    user = FactoryGirl.create(:user)
    car1 = FactoryGirl.create(:car)
    car2 = FactoryGirl.create(:car)

    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    within("#car_#{car1.id}") do
      click_link 'Claim'
    end

    expect(page).to have_text("#{car1.make} #{car1.model} has been saved to your inventory.")
    expect(page).to_not have_selector("#car_#{car1.id}")
    expect(page).to have_selector("#car_#{car2.id}")

    expect(page).to have_link('My Cars')
    click_link 'My Cars'

    expect(page).to have_selector("#car_#{car1.id}")
    expect(page).to_not have_selector("#car_#{car2.id}")
  end

  scenario 'allow a logged in user to unclaim a car' do
    user = FactoryGirl.create(:user)
    car1 = FactoryGirl.create(:car, user: user)
    car2 = FactoryGirl.create(:car)

    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    visit my_cars_path

    within("#car_#{car1.id}") do
      click_link 'unClaim'
    end

    expect(page).to have_text("#{car1.make} #{car1.model} has been removed from your inventory.")
    expect(page).to_not have_selector("#car_#{car1.id}")
    expect(page).to_not have_selector("#car_#{car2.id}")

    expect(page).to have_link('Cars')
    click_link 'Cars'

    expect(page).to have_selector("#car_#{car1.id}")
    expect(page).to have_selector("#car_#{car2.id}")
  end

  scenario 'show/hide link based on user being logged in' do
    user = FactoryGirl.create(:user)

    visit '/'

    expect(page).to have_link('Cars')
    expect(page).to_not have_link('My Cars')

    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_link('Cars')
    expect(page).to have_link('My Cars')
  end
end
