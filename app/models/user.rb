class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # class name - model class name, foreign_key used to connect 2 dbs
  # dependent - destroy destroys relationships upon user destroy.
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:  :destroy
  # source == overriding following array with set of followed ids                                
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates(:name, presence: true, length: {minimum: 4, maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false})
            
  has_secure_password
  validates(:password, presence: true, length: {minimum: 6}, 
            allow_nil: true)
  # password digest = hashed password
  
  #/\A              Start of regex and match start of string
  #   [\w+\-.] +    atleast one word char + hyphen or dot
  # @ [a-z\d\-.] +  literal @ symbol + atleast one letter, digit, hyphen, or dot.
  # \.[a-z] +       literal dot + atleast one letter
  # \z/i            match end of string and end of regex
  # http://www.rubular.com/ for testing regex.
  #/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for persistent sessions.
  def remember 
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  # Attribute can use string interpolation to use the function remember_digest
  # or activation digest depending on the need of the other methods.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user by updating their remember digest to nil
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Activates an account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # Sends an activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # Sends the password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Returns a true if password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # Defines a proto-feed.
  # "Following users" for full implementation
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # Followers a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  # Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  # Returns a boolean true of current user is following other user
  def following?(other_user)
    following.include?(other_user)
  end
  
  
  private 
    #converts the email to all downcase/lowercase
    def downcase_email
      self.email = email.downcase
    end
    
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
