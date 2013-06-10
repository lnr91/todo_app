module SessionsHelper


  def signed_in?()
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||=User.find_by_remember_token(cookies[:remember_token])
  end

  def sign_in(user)
    cookies.permanent[:remember_token]= user.remember_token
    self.current_user = user # Why do we need writer method current_user..cant we just assign it like @current_user=user inside sign_in method
  end

  def sign_out
    cookies.delete(:remember_token)
    current_user =nil
  end

  def redirect_back_or
    if !session[:return_to].nil?
     redirect_to(session[:return_to])
    else
      redirect_to controller: "pages",action: :home
    end
    session.delete(:return_to)
  end

  def signed_in_user
    unless signed_in?
     session[:return_to]= request.fullpath
     flash[:alert]="Please sign in"
     redirect_to signin_path
    end
  end

end
