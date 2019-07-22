require 'rails_helper'

# テストケース
# ・署名が不正の場合：ステータス４００が返る
# ・署名が正しく、テキストメッセージを受信した場合：ステータス２００を返す、受信したメッセージをそのまま返信する
# ・署名が正しく、テキストメッセージ以外を受信した場合：ステータス２００を返す、特定のメッセージを返信する



RSpec.describe MessageController, type: :request do
  # describe: テスト対象
  describe 'POST /callback' do
    
    # context: テストする状況、条件
    context 'message receive' do

      # it: テスト内容を is ~ で記載
      it 'is validation illegal signature' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "ABCDEFGHIJABCDEFGHIJABCDEFGHIJABCDEFGHIJ123="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "bad_signature.json" )) , :headers => headers
        
        # HTTPステータスが400であること
        expect(response.status).to eq(400)
      end
       
      it 'is received text message' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "W7JzRhzSx4GAbC5wMp3H27kR/lYtJugq0KkLCJj9ue4="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "text_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
      
      it 'is received other message' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "wvLkGQaEtkDd7xNa2vO7sAkcft9enB028BbCz/W57Jk="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "sticker_message.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end
        
    end
    
    context 'follow event' do
      it 'is new follower add' do
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "A2jhQOluPo1FUwhC7IUqot8W+tVBuYDBjwvpPl0Mw6s="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "follow_event.json" )) , :headers => headers
        
        expect(response.status).to eq(200)
      end

      it 'is block cancel' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604a1d' , :status => '00' , :del_flg => true)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "A2jhQOluPo1FUwhC7IUqot8W+tVBuYDBjwvpPl0Mw6s="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "follow_event.json" )) , :headers => headers
        expect(response.status).to eq(200)
      end
    end
    
    context 'unfollow event' do
      it 'is blocked' do
        User.create(:name => 'Test User' , :line_id => 'U01c7d4ac06b42fb8c59c2a1256604a1d' , :status => '00' , :del_flg => false)
        headers = {
          "Content-Type" => "application/json;charset=UTF-8",
          "X-Line-Signature" => "9N9xcqBaPCDsWLkga3pHb+SCyoETgU0FzOdOW93v/Ko="
        }
        post callback_path, :params => IO.read(Rails.root.join("spec", "support", "unfollow_event.json" )) , :headers => headers
        expect(response.status).to eq(200)
      end
    end
      
  end

end
