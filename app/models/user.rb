class User < ActiveRecord::Base
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
end
