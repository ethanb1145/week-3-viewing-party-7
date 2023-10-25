class UsersController <ApplicationController 
  before_action :require_login, only: [:show]
  
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end 

  def create 
    user = User.new(user_params)

    if user.password == user.password_confirmation
      if user.save
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        flash[:error] = user.errors.full_messages.to_sentence
        redirect_to register_path
      end
    else
      user.errors.add(:password_confirmation, "doesn't match Password")
      flash[:error] = "Password confirmation doesn't match Password"
      redirect_to register_path
    end
  end 

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "You have been logged out successfully."
    redirect_to root_path
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 

  def require_login 
    unless current_user
      flash[:error] = "You must be logged in."
      redirect_to root_path
    end
  end
end 