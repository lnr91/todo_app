class SessionsController < ApplicationController

  def new
    if signed_in?
    redirect_to root_path   # if already signed in , dontr show signin page...he is upto no good
    else
    render 'new',layout: 'signin_fail'
    end
  end
  def create
   user = User.find_by_email(params[:session][:email])
   if user && user.authenticate(params[:session][:password])
     sign_in user
     redirect_back_or
   else
     flash.now[:error]= "Invalid email/password"
     render 'new' ,layout: "signin_fail"
   end

  end

  def destroy
   sign_out
   redirect_to controller: :pages, action: :home
  end


end
