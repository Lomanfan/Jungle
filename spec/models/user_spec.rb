require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do

    it "creates a new user if first & last name, email, password, and valid password confirmation is provided" do
      @user = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      expect(@user).to be_valid
    end
    
    it 'fails to create a new user if first name is missing' do
      @user = User.new(
        first_name: nil,
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:first_name)).to include "First name can't be blank"
    end
 
    it 'fails to create a new user if last name is missing' do
      @user = User.new(
        first_name: 'Bart',
        last_name: nil,
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:last_name)).to include "Last name can't be blank"
    end

    it 'fails to create a new user if email is missing' do
      @user = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: nil,
        password: '45321',
        password_confirmation: '45321'
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:email)).to include "Email can't be blank"
    end

    it 'fails to create a new user if password is missing' do
      @user = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: nil,
        password_confirmation: '45321'
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:password)).to include "Password can't be blank"
    end

    it 'fails to create a new user if password_confirmation is missing' do
      @user = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: nil
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:password_confirmation)).to include "Password confirmation can't be blank"
    end

    it "fails to create new user if password and password_confirmation do not match" do
      @user = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '12345'
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:password_confirmation)).to include "Password confirmation doesn't match Password"
    end

    it "fails to create new user if password is less than 5 digits" do
      @user = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '453',
        password_confirmation: '453'
      )
      expect(@user).to be_invalid
      expect(@user.errors.full_messages_for(:password)).to include "Password is too short (minimum is 5 characters)"
    end

    it 'fails to create a new user if email exists' do
      @user1 = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user1.save
      @user2 = User.new(
        first_name: 'Bart2',
        last_name: 'Simpsons2',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user2.save
      expect(@user2).to be_invalid
      expect(@user2.errors.full_messages_for(:email)).to include "Email has already been taken"
    end

    it 'fails to create a new user if email exists and check case insensitivity' do
      @user1 = User.new(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user1.save
      @user2 = User.new(
        first_name: 'Bart2',
        last_name: 'Simpsons2',
        email: 'BART.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user2.save
      expect(@user2).to be_invalid
      expect(@user2.errors.full_messages_for(:email)).to include "Email has already been taken"
    end

  end

  describe '.authenticate_with_credentials' do

    it "returns an user instance if authentication is successful" do
      @user = User.create(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user.save
      @result = User.authenticate_with_credentials('Bart.bart@bart.com', '45321')
      expect(@result).to eq @user
    end

    it "returns nil if authentication is unsuccessful" do
      @user = User.create(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @result = User.authenticate_with_credentials('Bart.bart@bart.com', '123') #invalid password
      expect(@result).to eq nil
    end

    it "returns an user instance if (case insensitive) authentication is successful" do
      @user = User.create(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user.save
      @result = User.authenticate_with_credentials('BART.bart@bart.com', '45321') #email case insensitive
      expect(@result).to eq @user
    end

    it "returns a user instance if (email with leading/trailing whitespace) authentication is successful" do
      @user = User.create(
        first_name: 'Bart',
        last_name: 'Simpsons',
        email: 'Bart.bart@bart.com',
        password: '45321',
        password_confirmation: '45321'
      )
      @user.save
      @result = User.authenticate_with_credentials(' Bart.bart@bart.com ', '45321')
      expect(@result).to eq @user
    end

  end

end