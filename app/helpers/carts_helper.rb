module CartsHelper
        #ゲストIDを作成
        def create_guest_id
            if session[:guest_id].nil?
                guest_id = []
                (1..8).each do |i|
                    guest_id.push(SecureRandom.random_number(10))
                end 
            session[:guest_id] = guest_id.join
            end
        end

        def create_id_number
            if session[:user_id].nil?
                create_guest_id
                @id_number = session[:guest_id]
              else
                @id_number = session[:user_id]
              end
        end
end
