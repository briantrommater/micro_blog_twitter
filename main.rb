require 'sinatra'
require 'sinatra/activerecord'

require './user_models'
require './post_models'

enable :sessions
set :database, "sqlite3:main.sqlite3"

@user
@@Homeuserid
@@Homeusername
@@Homeuseremail


get '/' do  
    if session[:user_id] == nil
        return redirect '/signin' 
    elsif session[:user_id]
        @user = current_user
    end
    erb :home
end


get '/index' do
    erb :index 
end


get '/signin' do 
    erb :signin
end


get '/signup' do
    erb :signup
end

post '/signin' do
    
    # verification
    @user = User.where(user_name: params[:username]).first 
    
    if params[:username] == "" 
        erb :signin
        "You did not enter a username"
    else 
        if @user  
            if @user.password == params[:password] 
                session[:user] = @user.id
                @@Homeuserid = @user.id
                @@Homeusername = User.find(@@Homeuserid).user_name
                @@Homeuseremail = User.find(@@Homeuserid).email 
                redirect '/home'
            else
                erb :signin
                "wrong password"
            end
        else
            "no such username"
            erb :signup
        end
    end
end



post '/signup' do
    if params[:username] == ""
        "You did not enter a username"
    else
        @user = User.where(user_name: params[:username]).first
            if @user == params[:username]
                "That username is taken"
            else
                if  params[:email] == ""
                    "You did not enter an email"
                else
                    if params[:password] == ""
                      "You did not enter a password"
                    else
                        if params[:password] == params[:re_password]

                            User.create(user_name: params[:username], email: params[:email], password: params[:password], registered_at: Time.now.strftime("%d/%m/%Y %H:%M"))
                            erb :signin
                        else
                            "You passwords dont match"
                        end
                    end 
                end
            end
    end
end
    


post '/home' do
    @@Homeuserid = session[:user] 
    @@Homeusername = User.find(session[:user]).user_name
    @@Homeuseremail = User.find(session[:user]).email
    
        Post.create(user_id: @@Homeuserid, post: params[:tweet], posted_at: Time.now.strftime("%d/%m/%Y %H:%M"))
   
    User.all 
    @tweets= Post.all.reverse
    erb :home
end


get '/home' do
    @@Homeuserid = session[:user] 
    @@Homeusername = User.find(session[:user]).user_name
    @@Homeuseremail = User.find(session[:user]).email
  
    @tweets= Post.all.reverse 
    erb :home
end



get '/user' do
    @user_tweets = Post.where(user_id: @@Homeuserid).all.reverse
     erb :user
end

post '/user'  do
    erb :user
end

post '/bye' do 
    @@Homeuserid
    @@Homeusername
    @@Homeuseremail
    Post.all
    Post.where(user_id: @@Homeuserid).destroy_all
    User.all
    User.where(user_name: @@Homeusername).first.delete
     
    redirect './'
end

post '/update' do
    @@Homeuserid
    @@Homeusername
    @@Homeuseremail
    User.all
    if params[:username] == ""
        "You did not enter a username"
    else 
        if  params[:email] == ""
            "You did not enter an email"
        else
            if params[:password] == ""
                "You did not enter a password"
            else
                if params[:password] == params[:re_password]
                    User.where(user_name: @@Homeusername).update(user_name: @@Homeusername, email: params[:email], password: params[:password])
                    erb :signin
                else
                    "You passwords dont match"
                end
            end
        end
    end 
end

get '/users' do    
    @@Homeuserid = session[:user] 
    @name = User.find(session[:user]).user_name
    @name_email = User.find(session[:user]).email
    redirect "/users/#{@name}"  
    
end
 
get '/users/:name' do
    @users = User.all
    @name = params[:name]
    @name_email = User.where(user_name: params[:name]).first.email 
    @name_id = User.where(user_name: params[:name]).first.id
    @name_post = Post.where(user_id: @name_id).all
    erb :users
  end
 