class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  after_create :setUserAddress

  has_many :companies, dependent: :destroy  
  has_many :addresses, dependent: :destroy  
  has_many :carts, dependent: :destroy  
  has_many :notifications, dependent: :destroy    
  has_many :coupons
  has_many :invoices   
  
  accepts_nested_attributes_for :addresses  
  accepts_nested_attributes_for :invoices         
  has_attached_file :avatar, 
                    styles: { original: "200x200>" },
                    default_url: "default_avatar.png"  
  validates_attachment :avatar, 
                       content_type: { content_type: /\Aimage\/.*\Z/, message: "圖片格式錯誤" }, 
                       size: { less_than: 10.megabytes, message: "圖片大小超過10MB" }  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update         

  validates :last_name, presence: { presence: true, message: '請填寫 姓' }
  validates :first_name, presence: { presence: true, message: '請填寫 名' }
          
       
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?              
        uri = URI.parse(auth.info.image)
        uri.scheme = 'https'      
        user = User.new(
          first_name: auth.extra.raw_info.first_name,
          last_name: auth.extra.raw_info.last_name, 
          #username: auth.info.nickname || auth.uid,
          avatar: uri,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end      

  def active_for_authentication?
    super && !self.blocked_c
  end           
private
  def setUserAddress
    companies.create(activated_c: false)
    notifications.create(category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_VERIFY'], 
                         content: '立刻驗證獲得30元回饋金')
    
  end         
end
