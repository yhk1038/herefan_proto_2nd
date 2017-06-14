class HfUtilController < ApplicationController
    layout '../hf_util/layout'

    # 데이터베이스에 History (TWICE) 더미 입력
    # GET '/hf_util/history/dummy/push'
    def dummy_push
	# 나중에 이렇게 바꾸면 좋을 듯.
	# /hf_util/:model/dummy/push(/:pick)
	History.create!([
		{fandom_id: 2, event_date: DateTime.new(2015,11,1), title: "Reach third place in the Inkikayo"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,1), title: "1st mini album fanmeeting in incheon"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,3), title: "Arirang tv School club"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,3), title: "Celebriting video released for \"Like OOH-AAH\" MV 7million views"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,4), title: "Appear on the M-net \"오늘하룸(Today's room)\"(Ep01~Ep03)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,4), title: "Part time job event in CGV Yongsan"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,5), title: "1st Mini album Fan sign-meeting In Sinchon"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,5), title: "Jeongyeon&Momo birthday party(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,5), title: "Mcount down"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,6), title: "Twice tv2 Ep03(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,6), title: "Arirang TV simply kpop"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,6), title: "KBS MusicBank"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,7), title: "1st Mini album Fan sign-meeting in Gangnam"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,7), title: "MBC show music core"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,8), title: "SBS Inkikayo"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,9), title: "1st Surprise Visit lecture room(Yeonsei Univ.)(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,10), title: "SBS MTV The Show4 "},
		{fandom_id: 2, event_date: DateTime.new(2015,11,11), title: "2nd Surprise Visit lecture room(Municipal Seoul Univ.)(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,12), title: "3rd Surprise Visit lecture room(Gacheon Univ.)(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,12), title: "Twice Cheerleader!(ver. Stage)(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,12), title: "mbc fm4u Hopeful song of afternoon"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,13), title: "Twice tv2 Ep04(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,13), title: "Super K-pop Radio"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,13), title: "Arirang TV Simply Kpop"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,13), title: "KBS Music bank"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,14), title: "1st mini album Fan sign-meeting in Yongsan Lotte Cinema"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,14), title: "MBC Show! Music Core"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,15), title: "Twice's Surprise Visit(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,15), title: "SBS Inkikayo"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,17), title: "Arirang TV Pops In Seoul"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,17), title: "SBS MTV The Show4 "},
		{fandom_id: 2, event_date: DateTime.new(2015,11,19), title: "Take the end of fall(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,20), title: "Twice tv2 Ep05(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,20), title: "Arirang tv simply kpop"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,20), title: "Pop squere with Kim Sung Ju"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,21), title: "1st Mini album Fan sign-meeting in Bundang TLI Art center"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,21), title: "MBC Show! Music Core"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,23), title: "Attend \"Dorihwaga\" preview show in CGV wangsimni"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,24), title: "Snoopi the peanut "},
		{fandom_id: 2, event_date: DateTime.new(2015,11,25), title: "Mwave MEET&GREET "},
		{fandom_id: 2, event_date: DateTime.new(2015,11,26), title: "YTN RADIO Happy radio show"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,26), title: "Twice becomes a kindergarten(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,27), title: "Twice TV2 Ep06(Vlive)"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,27), title: "Mr. Baekdw's The three great kings"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,27), title: "KBS Music bank"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,28), title: "NEXON Elsword Commercial & Celebriting Dance Performance"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,28), title: "MBC Show! Music Core & Mini Fan meeting"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,29), title: "1st mini album fan sign-meeting in Yeongdeoung po"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,29), title: "SBS Inkikayo"},
		{fandom_id: 2, event_date: DateTime.new(2015,11,28), title: "My little television"}
	])
	History.delete_all if params[:to_do] == 'delete'
 	return render json: { count: History.count, data: History.all}
    end
    
    # 사용자가 중복된 myfandom을 가지게 되는 경우
    # 중복을 제거하도록 하는 실행 명령 함수
    #
    # GET 'hf_util/user_must_have_unique_myfandom/:id'
    def user_must_have_unique_myfandom
        
        ## 꼽사리 잠깐 낄께요 ~
        check_and_modify_record_value_for_error_fix
        ## 꼽사리 끝 ~
        
        
        me = User.find(params[:id])
        myfandoms = me.myfandoms
        count = myfandoms.count

        @deleted_myfandoms = []
        
        me.myfandoms.each do |myfandom|
            next if me.myfandoms.where(fandom: myfandom.fandom).count <= 1
    
            me.myfandoms.where(fandom: myfandom.fandom).each do |mf|
                next if me.myfandoms.where(fandom: mf.fandom).count <= 1
                @deleted_myfandoms << mf.delete
            end
        end
        
        count2 = me.myfandoms.count

        @report = {
                '결과 요약': "#{me.name}님에 연결된 채널 기존 '#{count}'개 중 '#{count - count2}'개의 중복을 발견해 '#{@deleted_myfandoms.count}'개를 성공적으로 제거하였습니다. 현재 연결된 채널은 '#{count2}'개 이며, 중복은 없습니다.",
                '사용자': # me.to_s,
                        {
                                id: me.id,
                                '닉네임': me.nickname,
                                '이름': me.name,
                                '이메일': me.email,
                                '생년월일': me.birthday.strftime('%F')
                        },
                '상세 내역': {
                        '수정 \'이전\' 연결된 채널': {
                                '갯수': "#{myfandoms.count}개",
                                '목록': myfandoms.map{|mf| mf.fandom.name}
                        },
                        '중복이 발견된 채널': {
                                '갯수': "#{@deleted_myfandoms.uniq.count}개",
                                '목록': @deleted_myfandoms.uniq.map{|df| df.fandom.name}
                        },
                        '수정 \'이후\' 연결된 채널': {
                                '갯수': "#{me.fandoms.count}개",
                                '목록': me.fandoms.map{|fd| fd.name}
                        }
                },
                data: {
                        size: me.fandoms.count,
                        channels: me.fandoms
                }
        }
        
        respond_to do |format|
            format.html do
                @report[@report.first[0]] = "<span class='value'>#{@report.first[1]}</span>"
                @report = @report.transform_keys{|key| "<span class='key'>#{key}</span>"}
                render params[:action]
            end
            format.json { render json: @report }
        end
    end
    
    
    # 임시 함수
    # 데이터베이스에 콘솔을 통해 접근할 수 없고,
    # 스키마 상의 에러에 의해 작업물 변경이 요구되어 만들게 됨.
    #
    # 다음 함수로 부터 호출되도록 만들어짐.
    # 5:7 'hf_util/user_must_have_unique_myfandom/:id'
    def check_and_modify_record_value_for_error_fix
        Link.update_all(type: nil)
    end
end
