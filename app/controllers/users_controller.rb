class UsersController < ApplicationController

  before_filter(only:[:show]) { |c| c.correct_user params[:id] }


  def new
    if signed_in?
      redirect_to root_path   # if already signed in , dontr show signup page...he is upto no good
    else
      @user = User.new()
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to controller: "pages",action: "home"
    else
      render 'new'
    end
  end

  def show
  # the helper method correct_user sets @user variable
  end

end
