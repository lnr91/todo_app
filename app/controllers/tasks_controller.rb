class TasksController < ApplicationController

  before_filter :signed_in_user
  before_filter {|c| c.correct_user params[:user_id] }
  before_filter :find_list, only: [:create,:complete,:destroy,:update]    # why not use for update and destroy also ? ...maybe its not strictly necessary bcos we have used correct_user method...but it comes i use when we delete a task which is present in on list from another list...rhink bout it


  def create
    @task = @list.tasks.build(params[:task])
    respond_to do |format|
      format.js
    end
  end

  def update
    @task=@list.tasks.find(params[:id])
    @task.update_attributes(params[:task])
    respond_to do |format|
      format.html { redirect_to [current_user,@list], notice: 'Task completed' }
      format.js
    end
  end

  def destroy
    @task = @list.tasks.destroy(params[:id])   # destroy method returns the destroyed object, but since we used @list.tasks.destroy ...it returns array which contains destroyed object
   @task = @task.first
    respond_to do |format|
      format.js
    end
  end

  private

  def find_list
    redirect_to root_path unless @list= current_user.lists.find_by_id(params[:list_id])
  end

end
