require 'rails_helper'

feature 'User Authentication' do
  scenario 'allows a user to signup' do
    visit '/'

    expect(page).to have_link('Signup')

    click_link('Signup')

    fill_in 'First Name', with: 'Bob'
    fill_in 'Last Name', with: 'Smith'
    fill_in 'Email', with: 'bob@smith.com'
    fill_in 'Password', with: 'sup3rs3krit'
    fill_in 'Password Confirmation', with: 'sup3rs3krit'
    click_button 'Signup'

    expect(page).to have_text('Thank you for signing up Bob')
    expect(page).to have_text('Signed in as bob@smith.com')
  end

  scenario 'allows existing users to login' do
    user = FactoryGirl.create(:user)

    visit '/'

    expect(page).to have_link('Login')

    click_link('Login')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_text("Welcome back #{user.first_name}")
    expect(page).to have_text("Signed in as #{user.email}")
  end

  scenario 'does not allow existing users to login with an invalid password' do
    user = FactoryGirl.create(:user)

    visit '/'

    expect(page).to have_link('Login')

    click_link('Login')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'NOT_YOUR_PASSWORD'
    click_button 'Login'

    expect(page).to have_text("Invalid credentials")
    expect(page).to_not have_text("Signed in as #{user.email}")
  end

  scenario 'allows a logged in user to logout' do
    user = FactoryGirl.create(:user)

    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_text("Welcome back #{user.first_name}")
    expect(page).to have_text("Signed in as #{user.email}")

    expect(page).to have_link('Logout')

    click_link 'Logout'

    expect(page).to have_text("#{user.email} has been logged out")
    expect(page).to_not have_text("Welcome back #{user.first_name}")
    expect(page).to_not have_text("Signed in as #{user.email}")
  end
end
