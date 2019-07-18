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
  
  end

end