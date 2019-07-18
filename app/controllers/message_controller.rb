class MessageController < ApplicationController
    
    require 'line/bot'
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
        puts body
        
        # 署名検証
        hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], body)
        signature = Base64.strict_encode64(hash)
        req_signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless signature.eql?(req_signature)
            render :status => 400 , :json => { error: "invalid_request" , error_description: "some parameters missed or invalid" }
            return
        end
        
        events = client.parse_events_from(body)
        events.each do |event|
            
            case event
            # Messgae Event
            when Line::Bot::Event::Message
                
                case event.type
                # Text Message
                when Line::Bot::Event::MessageType::Text
                    message = {
                        type: 'text',
                        text: event.message['text'] + '...?'
                    }
                    client.reply_message(event['replyToken'], message)
                when Line::Bot::Event::MessageType::Sticker
                    message = {
                        type: 'text',
                        text: 'いいスタンプだね！'
                    }
                    client.reply_message(event['replyToken'], message)
                # Image , Video Message
                when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
                    response = client.get_message_content(event.message['id'])
                    tf = Tempfile.open("content")
                    tf.write(response.body)
                end
            end
        end
        
        render :status => 200 , :json => { }
        return
    end
    
end
