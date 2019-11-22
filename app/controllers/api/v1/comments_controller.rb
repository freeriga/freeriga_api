module Api::V1
  class Api::V1::CommentsController < ApiController
    load_and_authorize_resource only: :create
    
    def create
      if params[:entry_id]
        @item = Entry.find(params[:entry_id]).item
      elsif params[:task_id]
        @item = Task.find(params[:task_id])
      elsif params[:location_id]
        @item = Location.find(params[:location_id])
      elsif params[:quarter_id]
        @item = Quarter.find(params[:quarter_id])
      elsif params[:comment_id]
        @item = Comment.find(params[:comment_id]).item
      end
      @comment = Comment.new(comment_params)
      @comment.item = @item
      if @comment.save
        # render json: CommentSerializer.new(@comment).serialized_json, status: :created
        # render json: { data: {body: @comment.body, colour: @comment.colour, created_at: @comment.created_at, id: @comment.id,
          # item_id: @comment.item_id, item_type: @comment.item_type, location_id: @comment.location_id, updated_at: @comment.updated_at,
          # username: @comment.username, entry_id: @item.entry_id}}, status: :created
          if [Location, Quarter].include?(@item.class)
            render json: EntrySerializer.new(@comment.entry).serialized_json, status: :created
          else
            render json: EntrySerializer.new(@item.entry).serialized_json, status: :created
          end
      else
        respond_with_errors(@comment)
      end
    end

    def index
      if params[:quarter_id]
        quarter = Quarter.find(params[:quarter_id])
        @comments = comments.tasks
      elsif params[:location_id]
        location = Location.find(params[:location_id])
        @comments = location.comments
      else
        @comments = Comment.all
      end
      render json: CommentSerializer.new(@comments, include: [:item, :'item.entry']).serialized_json, status: 200
    end

    protected
      def comment_params
        params.require(:comment).permit(:username, :location_id, :user_id, :colour, translations_attributes: [:id, :locale, :body, :_destroy])
      end

  end
end
