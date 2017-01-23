require 'rails_helper'

describe User do

	describe '#generating password code' do

		it "should produce code exactly 5 characters long and having only digits" do
			password_code = User.generate_password_code

			expect(password_code).to match(/\d{5}/)
		end
	end	
end