class ListsController < ApplicationController


  before_filter :signed_in_user   # though correct_user talso takes care of signed_in, we need this bcos of session[:return_to]= request.fullpath...its nice to have it

  before_filter {|c| c.correct_user params[:user_id] }

  def show
    @list = List.find(params[:id])
    @task = @list.tasks.build
  end

  def create
    @list= current_user.lists.build(params[:list])
     respond_to do |format|
       format.js
     end
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list.update_attributes(params[:list])
      redirect_to @list, notice: "List updated successfully"
    else
      render 'edit'
    end
  end

  def destroy
    @list = List.destroy(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
