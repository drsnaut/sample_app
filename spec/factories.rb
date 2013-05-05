FactoryGirl.define do
	factory :user do
		name "MichaelHartl"
		email "michael@example.com"
		password "foobar"
		password_confirmation "foobar"
	end
end