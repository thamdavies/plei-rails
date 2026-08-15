class UsersController < ApplicationController
  def index
    run(User::Operations::Index) do |result|
      @pagy, users = pagy(result[:users], limit: Settings.pagination.default_per_page)
      @users = users.decorate
    end

    render Views::Users::Index.new(pagy: @pagy, users: @users)
  end

  def new
    run(User::Operations::Create::Present) do |result|
      @form = result[:"contract.default"]
    end
  end

  def create
    ctx = User::Operations::Create.call(params: permit_params.to_h)

    if ctx.success?
      flash.now[:success] = "User created successfully"

      run(User::Operations::Index) do |result|
        @pagy, users = pagy(result[:users], limit: Settings.pagination.default_per_page)
        @users = users.decorate
      end
    else
      @form = ctx[:"contract.default"]
    end
  end

  private

  def permit_params
    params.require(:form).permit(
      :id,
      :username,
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
    )
  end
end
