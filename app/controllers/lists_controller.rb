class ListsController < ApplicationController

  before_filter :signed_in_user

  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
    @task = Task.new()
  end

  def new
    @list = List.new()
  end

  def create
    @list= current_user.lists.build(params[:list])
    if @list.save
      flash[:notice]= "New List created"
      redirect_to controller: "pages", action: :home
    else
=begin
      flash[:error]= "Could not create list"
      redirect_to controller: "pages",action: :home
=end
      if @list.errors.any?
        session[:list_errors]=@list.errors
      end
      session[:list_name]= params[:list][:name]
      session[:list_description]= params[:list][:description]
      redirect_to controller: "pages", action: :home
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
    @list = List.find(params[:id])
    if @list.destroy
      redirect_to lists_path, notice: "Deleted list"
    end
  end
end
