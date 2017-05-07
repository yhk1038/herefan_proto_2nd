RailsAdmin.config do |config|
    config.main_app_name = ['BackOffice - HereFan :: DB']

    # Model Config
    config.included_models = %w(Fandom Link User Myfandom VisitedLink)
    # config.config.excluded_models = %w()
    
    config.model 'Fandom' do
        label '채널'
        label_plural '채널'
        navigation_icon 'icon-flag'
    end

    config.model 'Link' do
        label '라이브러리 컨텐츠'
        label_plural '라이브러리 컨텐츠'
        navigation_icon 'icon-th'
    end

    config.model 'User' do
        label '사용자'
        label_plural '사용자'
        navigation_icon 'icon-user'
    end

    config.model 'Myfandom' do
        label '채널 팔로우'
        label_plural '채널 팔로우'
        navigation_icon 'icon-heart'
    end

    config.model 'VisitedLink' do
        label '조회된 컨텐츠'
        label_plural '조회된 컨텐츠'
        navigation_icon 'icon-glass'
    end
    
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
