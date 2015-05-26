class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates(:name, presence: true, length: {minimum: 4, maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false})
            
  has_secure_password
  validates(:password, length: {minimum: 6})
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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # Forgets a user by updating their remember digest to nil
  def forget
    update_attribute(:remember_digest, nil)
  end
end
