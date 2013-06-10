  class TasksController < ApplicationController

    before_filter :find_list, only: [:create,:complete]
    before_filter :signed_in_user

    def create
      @task = @list.tasks.build(params[:task])
      if @task.save
        redirect_to [current_user,@list], notice: "New task created"
      else
        render 'lists/show'
      end
    end

    def complete
      @list= List.find(params[:list_id])
      @task=@list.tasks.find(params[:task_id])
      @task.completed=true
      @task.save
      redirect_to [current_user,@list], notice: 'Task completed'
    end


    private

    def find_list
      @list= current_user.lists.find(params[:list_id])
    end

  end
