module Api::V1
  class Api::V1::UsersController < ApiController
    # load_and_authorize_resource only: :create

    def update
      @user = User.find(params[:id])
      if can? :update, @user
        if @user.update(user_params)
          render json: UserSerializer.new(@resource, {include: [:location]}).serialized_json, status: 200
        else
          respond_with_errors(@user)
        end
      else
        render_403(:update, @user)
      end
    end

    protected

    def user_params
      params.require(:user).permit(:nickname, :name, :avatar)
    end
  end
end