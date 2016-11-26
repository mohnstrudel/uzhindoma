class AddOtpSecretKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :otp_secret_key, :string
  end

  User.all.each { |user| user.update_attribute(:otp_secret_key, ROTP::Base32.random_base32) }
  
end
