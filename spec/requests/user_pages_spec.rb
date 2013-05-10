require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "profilepage" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
	
		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title',text: user.name) }
	end

	describe "Signup page" do
		before { visit signup_path }
		it { should have_selector 'h1', text: 'Sign up'  }
		it { should have_selector 'title', text: 'Sign up' }
	end
	
	describe "signup" do
		before { visit signup_path }
		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it { should have_selector 'title', text: 'Sign up' }
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission and no data introduced" do
				before { click_button submit }
				it { should have_content 'The form contains 5 errors.' }
			end
			
			describe "after submission w/ invalid mail" do
				before do
					fill_in "Email", with: "foo@@bar.com"
					click_button submit
				end

				it { should have_content 'The form contains 4 errors.' }
				it { should have_content 'Email is invalid' }
			end

			describe "after submission w/ short password and no confirmation" do
				before do
					fill_in "Password", with: "foo"
					click_button submit
				end

				it { should have_content 'The form contains 5 errors.' }
				it { should have_content "Password is too short (minimum is 6 characters)" }
			end

			describe "after submission w/ password mismatch and short" do
				before do
					fill_in "Password", with: "foo"
					fill_in "Confirmation", with: "bar"
					click_button submit
				end

				it { should have_content 'The form contains 5 errors.' }
				it { should have_content "Password doesn't match confirmation" }
				it { should have_content "Password is too short (minimum is 6 characters)" }
			end

		end

		describe "with valid information" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let (:user) { User.find_by_email 'user@example.com' }

				it { should have_selector 'title', text: user.name }
				it { should have_selector 'div.alert.alert-success', text: 'Welcome'}
				it { should have_link('Sign out') }
			end
		end
	end

end

