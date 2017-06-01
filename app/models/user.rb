class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PictureUploader

  has_many :orders, dependent: :destroy
  
  has_many :addresses
  accepts_nested_attributes_for :addresses, allow_destroy: true


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

  def self.password_recovery_via_sms(phone)

    if(phone.length == 18 or phone.length == 12)

      password = self.generate_password_code
      user = self.where(phone: phone).first

      # Если не находим пользователя, то сразу его создаем
      if not user
        self.create(phone: phone, password: password)
        logger.debug("New user with phone - #{phone} created!")
      else
        if user.update(password: password)
          logger.debug("New password for user #{user.email} successfully updated")
        else
          logger.debug("Password failed to update")
        end
      end
      
      stripped_phone = phone.gsub(/\s+/, "").gsub(/[()]/, "").gsub(/-/, "")
      encoded_phone = CGI.escape(stripped_phone)
      encoded_message = CGI.escape("Ваш новый пароль - #{password}.")
      logger.debug("New password for user #{phone} - #{password}")
      logger.debug("Calling 'sms_deliver' with phone: #{encoded_phone} and message: #{encoded_message}")
      Sms.sms_deliver(encoded_phone, encoded_message)
    end
    puts "---------"
    puts "SMS sent to #{phone}!"
  end

  def update_orders_from_bitrix(bitrix_id)
    b_orders = Bitrix.get_users_orders(bitrix_id)["result"]

    b_orders.each do |one_bitrix_order|
      order_name = ""
      
      # Получаем названия товаров для заказа
      Bitrix.get_productrows_for_order(one_bitrix_order["ID"]).each do |productrow|       
        order_name += ";#{productrow["PRODUCT_NAME"]}"
      end
      
      self.orders.create(name: order_name, order_type: "Import from Bitrix", order_price: one_bitrix_order["OPPORTUNITY"], created_at: one_bitrix_order['BEGINDATE'], bitrix_order_id: one_bitrix_order["ID"].to_i)
    end
    if update(orders_updated: true)
      logger.debug("./././././././")
      logger.debug("User updated with orders. From now on loading only from own DB")
    end
  end

end