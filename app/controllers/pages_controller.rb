class PagesController < ApplicationController

  def home
    if signed_in?
      @lists = current_user.lists.all  # if u put only @lists= current_user.lists ...then if it is empty I think it doesnt return nil
     @new_list = current_user.lists.new   #changed from build to new
     if session[:list_errors]
       session[:list_errors].each {|error,error_message| @new_list.errors.add error, error_message}
       session.delete :list_errors
     end
    end
  end

end