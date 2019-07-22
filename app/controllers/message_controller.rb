class MessageController < ApplicationController
    
    require 'line/bot'
    require 'json'
    require 'aws-sdk-s3'
    protect_from_forgery :except => [:callback]
    
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_id = ENV["LINE_CHANNEL_ID"]
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
    
    def callback
        body = request.body.read
        
        # 署名検証
        hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], body)
        signature = Base64.strict_encode64(hash)
        puts signature
        req_signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless signature.eql?(req_signature)
            render :status => 400 , :json => { error: "invalid_request" , error_description: "some parameters missed or invalid" }
            return
        end
        events = client.parse_events_from(body)
        events.each do |event|
            
            userId = event['source']['userId']
            
            case event
            
            # follow Event
            when Line::Bot::Event::Follow
                
                followUser = User.find_by_line_id(userId)
                if followUser.nil?
                    # User regist
                    followUser = User.new
                    followUser.name = 'New User'
                    followUser.line_id = userId
                    followUser.status = '00'
                    
                    # follow message send
                    message = {
                        type: 'text',
                        text: 'フォローありがとう！'
                    }
                else
                    followUser.del_flg = false
                    # follow message send
                    message = {
                        type: 'text',
                        text: 'ブロ解ありがとう！'
                    }
                end
                
                unless followUser.save
                    # error handle
                end
                
                client.reply_message(event['replyToken'], message)
            
            # Unfollow Event
            when Line::Bot::Event::Unfollow
                
                unfollowUser = User.find_by_line_id(userId)
                unfollowUser.del_flg = true
                unless unfollowUser.save
                    # error handle
                end
                
            # Messgae Event
            when Line::Bot::Event::Message
                
                # Message regist
                receiptMessage = Message.new
                receiptMessage.message_id = event.message['id']
                receiptMessage.message_type = event.message['type']
            
                case event.type
                # Text Message
                when Line::Bot::Event::MessageType::Text
                    
                    receiptMessage.request = event.message['text']
                    
                    message = {
                        type: 'text',
                        text: event.message['text'] + '...?'
                    }
                    client.reply_message(event['replyToken'], message)
                    
                    receiptMessage.response = message
                    unless receiptMessage.save
                        # error handle
                    end
                    
                when Line::Bot::Event::MessageType::Sticker
                    
                    receiptMessage.request = 
                        JSON.parse('{ "packageId":' + event.message['packageId'] + ',' + '"sickerId":' + event.message['stickerId'] + '}')
                    
                    message = {
                        type: 'text',
                        text: 'いいスタンプだね！'
                    }
                    
                    client.reply_message(event['replyToken'], message)
                    receiptMessage.response = message
                    unless receiptMessage.save
                        # error handle
                    end
                    
                # Image , Video Message
                when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
                    response = client.get_message_content(event.message['id'])
                    
                    region = 'ap-northeast-1'
                    bucket_name = 'pbt-line-chatbot-tmp-strage'
                    key = userId
                    s3_client = Aws::S3::Client.new(region: region)
                    s3_client.put_object(bucket: bucket_name, key: key, body: response.body) 
                    
                    message = {
                        type: 'text',
                        text: '面白いね！'
                    }
                    
                    client.reply_message(event['replyToken'], message)
                    receiptMessage.response = message
                    unless receiptMessage.save
                        # error handle
                    end
                    
                end
            end
        end
        
        render :status => 200 , :json => { }
        return
    end
    
end
