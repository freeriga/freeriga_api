module Api::V1
  class Api::V1::TasksController < ApiController
    # load_and_authorize_resource only: :create

    def create
      if params[:location_id]
        @location = Location.find(params[:location_id])
      end
      @task = Task.new(task_params)
      @task.location = @location
      if @task.save
        render json: EntrySerializer.new(@task.entry).serialized_json, status: :created
      else
        respond_with_errors(@task)
      end
    end

    def index
      if params[:quarter_id]
        quarter = Quarter.find(params[:quarter_id])
        @tasks = quarter.tasks
      else
        @tasks = Task.all
      end
      render json: TaskSerializer.new(@tasks, include: [:comments]).serialized_json, status: 200
    end

    protected

      def task_params
        params.require(:task).permit(:status, :username, :user_location_id, :colour, :location_id, 
          translations_attributes: [:id, :locale, :summary, :_destroy])
      end
  end
end
