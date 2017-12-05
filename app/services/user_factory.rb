class UserFactory
  def self.by_email(email:)
    pwd = random_password
    User.new(email: email, password: pwd, password_confirmation: pwd)
  end

  private

  def self.random_password
    SecureRandom.base64
  end
end
