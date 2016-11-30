class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PictureUploader

  has_many :orders

  has_one_time_password column_name: :otp_secret_key, length: 4

  def self.create_password
  	('a'..'z').to_a.shuffle[0,8].join
  end

  def self.generate_password_code
    password = ('0'..'9').to_a.shuffle[0,5].join
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

end
