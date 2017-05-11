class HfUtilController < ApplicationController
    layout '../hf_util/layout'
    
    # 사용자가 중복된 myfandom을 가지게 되는 경우
    # 중복을 제거하도록 하는 실행 명령 함수
    #
    # GET 'hf_util/user_must_have_unique_myfandom/:id'
    def user_must_have_unique_myfandom
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
end
