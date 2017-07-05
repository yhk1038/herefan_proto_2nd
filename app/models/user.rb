class User < ApplicationRecord
    mount_uploader :image, StoragesUploader
    serialize :image, JSON
    
    # rolify
    # include Authority::UserAbilities
    
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :omniauthable, :omniauth_providers => [:facebook, :twitter, :google_oauth2]

    # has_many :links
    has_many :fd_confs
    belongs_to :fd_conf
    
    has_many :myfandoms, dependent: :destroy
    has_many :fandoms, through: :myfandoms
    has_many :histories
    has_many :links
    has_many :wiki_posts
    has_many :visited_links, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :clips, dependent: :destroy

    def fandom_lists
        self.myfandoms.all&.map{|mf| mf.fandom}
    end
    
    def is_planet_editor?(fandom)
        fandom.user_ids.include? self.id
    end
    
    def profile_img
        self.img.nil? ? fake_helper_image_with_sns(self.image.to_s) : self.img
    end
    
    # after_create :set_default_role, if: Proc.new { User.count > 1 }

    TEMP_EMAIL_PREFIX = 'change@me'
    TEMP_EMAIL_REGEX = /\Achange@me/
    TEMP_EMAIL_HEREFAN = '@herefan.com'

    validates_presence_of :name
    validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

    ## DEVISE OFFICAIL GUIDE
    def self.from_omniauth(auth)
        u = where(provider: auth.provider, uid: auth.uid).first
        u = recoverage(auth) if u.nil?
        
        if u.nil?
            u = User.create do |user|
                email = auth.info.email
                unless email
                    email = auth.info.name.gsub(' ', '_') + TEMP_EMAIL_HEREFAN
                end
                if User.where(email: email).count > 0
                    email = "#{auth.provider}_user-"+email
                end
                user.email      = email
                user.password   = user.email
                user.provider   = auth.provider
                user.uid        = auth.uid
                user.name       = auth.info.name  # assuming the user model has a name
                user.image      = auth.info.image # assuming the user model has an image
                user.img        = auth.info.image
                
                user.nickname   = user.name
                # If you are using confirmable and the provider(s) you use validate emails,
                # uncomment the line below to skip the confirmation emails.
                # user.skip_confirmation!
            end
        end
        
        return u
    end

    # 인증 앱 변경으로 인해, 같은 소셜 계정이지만 provider의 uid 값이 변경되는 현상이 있었다.
    # 이로 인해 서버에서는 새로운 user로 인식해 가입을 시도하지만, 기존 가입된 동일계정의 email과 email이 중복되어 create 과정에서 오류가 발생했다.
    # 따라서 인증 앱 변경 시점인 2017-07-05 일을 기준으로 이전에 가입된 계정들을 '기존 user'로 분류하고,
    # 이들에 한해 다음의 로직을 적용하여 해결했다.
    # > 같은 provider일때 email이 중복되지만 uid만 다른 경우에,
    # > 기존 계정의 uid를 새로운 인증 앱에서 반환하는 uid로 변경한 뒤,
    # > 새로운 계정 생성을 막고, 기존 계정을 현재 세션으로 인식하도록 기존 계정을 반환한다.
    def self.recoverage(auth)
        email = auth.info.email
        email = auth.info.name.gsub(' ','_') + TEMP_EMAIL_HEREFAN unless email
        user = User.where(provider: auth.provider, email: email).take
        return nil if user.nil? || (user.created_at.to_time > Time.new(2017, 7, 6))

        user.update(uid: auth.uid)
        return user
    end

    ## GITBOOK GUIDE
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
                user = User.new(
                        name: auth.info.name || auth.extra.nickname ||  auth.uid,
                        email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
                        password: Devise.friendly_token[0,20]
                )
                user.skip_confirmation!
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

    def my_update_with_password(user_params)
        status = false
        if self.valid_password?(user_params[:current_password])
            user_params.permit!.each do |key, value|
                if value.to_s.length.zero?
                    user_params.except!(key.to_s.to_sym)
                else
                    if key.to_s == 'password'
                        if value != user_params[:password_confirmation]
                            user_params.except!(key.to_s.to_sym)
                            user_params.except!(:password_confirmation)
                            user_params[:password] = user_params[:current_password]
                        end
                    end
                    
                    if key.to_s == 'image'
                        self.update(img: nil)
                    end
                end
                user_params.except!(:current_password)
            end
            status = self.update(user_params)
            # raise :test
        end
        
        return status
    end
    
    private
    def set_default_role
        add_role :user
    end
    
    def fake_helper_image_with_sns(img_path)
        is_contain = false
        default_profile_img = SiteMaster.first_or_create.default_profile_image
        return default_profile_img if img_path.include? default_profile_img
    
        split = img_path.split('%3A//')
        path        = split.last
        protocol    = split.first.split('/').last
    
        sns_asset_domains.each do |domain|
            is_contain = true if path.include? domain
        end
    
        return is_contain ? protocol + path : img_path
    end

    def sns_asset_domains
        %w(graph.facebook.com pbs.twimg.com lh3.googleusercontent.com)
    end
end
