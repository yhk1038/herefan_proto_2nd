RailsAdmin.config do |config|
    config.main_app_name = ['BackOffice - HereFan :: DB']

    # Model Config
    config.included_models = %w(
                                Fandom
                                Schedule
                                Link
                                User
                                Myfandom
                                VisitedLink
                                History
                                Wiki
                                WikiPointer
                                WikiPost
                                FdConf
                                SiteMaster
                            )
    # config.config.excluded_models = %w()
    
    config.model 'Fandom' do
        label 'ㄱ. 플래닛'
        label_plural '플래닛'
        navigation_icon 'icon-flag'
    end

    config.model 'FdConf' do
        label 'ㄴ. 플래닛 세팅 정보'
        label_plural '플래닛 세팅 정보'
        navigation_icon 'icon-glass'
    end

    config.model 'Link' do
        label 'ㄷ. 라이브러리 컨텐츠'
        label_plural '라이브러리 컨텐츠'
        navigation_icon 'icon-th'
    end
    
    config.model 'Schedule' do
        label 'ㄹ. 스케쥴 항목'
        label_plural '스케쥴 항목'
        navigation_icon 'icon-calendar'
    end

    config.model 'User' do
        label 'ㅁ. 사용자'
        label_plural '사용자'
        navigation_icon 'icon-user'
    end

    config.model 'Myfandom' do
        label 'ㅂ. 채널 팔로우'
        label_plural '채널 팔로우'
        navigation_icon 'icon-heart'
    end

    config.model 'VisitedLink' do
        label 'ㅅ. 조회된 컨텐츠'
        label_plural '조회된 컨텐츠'
        navigation_icon 'icon-glass'
    end

    #
    config.model 'History' do
        label 'ㅇ. 히스토리'
        label_plural '히스토리'
        navigation_icon 'icon-glass'
    end
    
    config.model 'Wiki' do
        label 'ㅈ. 위키 문서'
        label_plural '위키 문서'
        navigation_icon 'icon-glass'
    end

    config.model 'WikiPointer' do
        label 'ㅊ. 위키 섹션 컨데이너'
        label_plural '위키 섹션 컨데이너'
        navigation_icon 'icon-glass'
    end

    config.model 'WikiPost' do
        label 'ㅋ. 위키 포스트'
        label_plural '위키 포스트'
        navigation_icon 'icon-glass'
    end

    config.model 'SiteMaster' do
        label 'ㅍ. 사이트 종합관리'
        label_plural '사이트 종합관리'
        navigation_icon 'icon-glass'
    end

    config.navigation_static_links = {
            '관리자 전용 콘솔' => 'http://test.herefan.com/console/admin',
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
