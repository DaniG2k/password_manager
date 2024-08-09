class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, only: %i[show edit update destroy]
  before_action :require_editable_permission, only: %i[edit update]
  before_action :require_deletable_permission, only: %i[destroy]

  def index
    @passwords = current_user.passwords
  end

  def show
  end

  def new
    @password = current_user.passwords.new
  end

  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)
    if @password.save
      redirect_to @password
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @password.update(password_params)
      redirect_to @password
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @password.destroy
      redirect_to passwords_path
    end
  end

  private

  def password_params
    params.require(:password).permit(
      :password,
      :url,
      :username,
    )
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
  end

  def require_editable_permission
    redirect_to @password unless current_user_password.editable?
  end

  def require_deletable_permission
    redirect_to @password unless current_user_password.deletable?
  end
end
