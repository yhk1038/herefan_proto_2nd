RailsAdmin.config do |config|
    config.main_app_name = ['BackOffice - HereFan :: DB']

    # Model Config
    config.included_models = %w(Fandom Link User Myfandom VisitedLink)
    # config.config.excluded_models = %w()
    
    config.model 'Fandom' do
        label 'ㄱ. 채널'
        label_plural 'ㄱ. 채널'
        navigation_icon 'icon-flag'
    end

    config.model 'Link' do
        label 'ㄴ. 라이브러리 컨텐츠'
        label_plural 'ㄴ. 라이브러리 컨텐츠'
        navigation_icon 'icon-th'
    end

    config.model 'User' do
        label 'ㄷ. 사용자'
        label_plural 'ㄷ. 사용자'
        navigation_icon 'icon-user'
    end

    config.model 'Myfandom' do
        label 'ㄹ. 채널 팔로우'
        label_plural 'ㄹ. 채널 팔로우'
        navigation_icon 'icon-heart'
    end

    config.model 'VisitedLink' do
        label 'ㅁ. 조회된 컨텐츠'
        label_plural 'ㅁ. 조회된 컨텐츠'
        navigation_icon 'icon-glass'
    end

    config.navigation_static_links = {
            Github: 'https://github.com/StarStreamOfficial/HereFan_renew',
            '레일즈 어드민 - 공식 문서' => 'https://github.com/sferik/rails_admin/wiki',
            '레일즈 어드민 - 한글 가이드' => 'https://say8425.github.io/setup-rails-admin-1/'
    }
    
    ### Popular gems integration
    
    ## == Devise ==
    config.authenticate_with do
      warden.authenticate! scope: :user
      redirect_to main_app.root_path unless current_user.try(:admin?)
    end
    config.current_user_method(&:current_user)
    
    ## == Cancan ==
    # config.authorize_with :cancan
    
    ## == Pundit ==
    # config.authorize_with :pundit
    
    ## == PaperTrail ==
    # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
    
    ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
    
    ## == Gravatar integration ==
    ## To disable Gravatar integration in Navigation Bar set to false
    # config.show_gravatar true
    
    config.actions do
        dashboard                     # mandatory
        index                         # mandatory
        new
        export
        bulk_delete
        show
        edit
        delete
        show_in_app
        
        ## With an audit adapter, you can add:
        # history_index
        # history_show
    end
end
