  class TasksController < ApplicationController

    before_filter :find_list, only: [:create,:complete]
    before_filter :signed_in_user
    before_filter {|c| c.correct_user params[:user_id] }


    def create
      @task = @list.tasks.build(params[:task])
      respond_to do |format|
        format.js
      end
    end

    def update
      @list= List.find(params[:list_id])
      @task=@list.tasks.find(params[:id])
      @task.update_attributes(params[:task])

      respond_to do |format|
        format.html { redirect_to [current_user,@list], notice: 'Task completed' }
        format.js

      end
    end

    def destroy
      @task = Task.destroy(params[:id])   # method returns the destroyed object
      respond_to do |format|
        format.js
      end
    end

    private

    def find_list
      @list= current_user.lists.find(params[:list_id])
    end

  end
