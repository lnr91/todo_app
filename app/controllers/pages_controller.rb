class PagesController < ApplicationController

  def home
    if signed_in?
      @lists = current_user.lists.all  # if u put only @lists= current_user.lists ...then if it is empty I think it doesnt return nil
     @new_list = current_user.lists.new   #changed from build to new...why ?
    end
  end

end