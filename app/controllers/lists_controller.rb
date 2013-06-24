class ListsController < ApplicationController


  before_filter :signed_in_user       # though correct_user also takes care of signed_in, we need this bcos of session[:return_to]= request.fullpath...its nice to have it
  before_filter  {|c| c.correct_user params[:user_id] }   # Use block form ....This is the way to send parameters to method used in before_filter
  before_filter  :find_list, only:[:show,:update,:destroy]

  def show
    @task = @list.tasks.build
  end

  def create
    @list= current_user.lists.build(params[:list])
     respond_to do |format|
       format.js
     end
  end

=begin  Haven't implemented edit action
  def edit
    @list = List.find(params[:id])
  end
=end

  def update
    if @list.update_attributes(params[:list])
      redirect_to @list, notice: "List updated successfully"
    else
      render 'edit'
    end
  end

  def destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def find_list
   redirect_to root_path unless @list= current_user.lists.find_by_id(params[:id])
  end

end
