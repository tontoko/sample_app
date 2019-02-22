class User < ApplicationRecord

    attr_accessor :remember_token
    # before_save { Self.email = email.downcase! }
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates   :email, presence: true, 
                length: { maximum: 255 }, 
                format: { with: VALID_EMAIL_REGEX },
                uniqueness: { case_sensitive: false }
    has_secure_password
    validates   :password, presence: true, length: { minimum: 6 }, allow_nil: true

    # # 渡された文字列のハッシュ値を返す
    # # def User.digest(string)
    # def self.digest(string)
    #     cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    #                                                 BCrypt::Engine.cost
    #     BCrypt::Password.create(string, cost: cost)
    # end

    # # ランダムなトークンを返す
    # # def User.new_token
    # def self.new_token
    #     SecureRandom.urlsafe_base64
    # end

    class << self
        # 渡された文字列のハッシュ値を返す
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ?   BCrypt::Engine::MIN_COST :
                                                            BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        # ランダムなトークンを返す
        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    # ↑クラスメソッドの定義の仕方いろいろ

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        # remember_digest = self.remember_digest
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end
