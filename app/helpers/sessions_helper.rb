module SessionsHelper
  
  def render_account_dropdown
    if current_user
      render 'users/account_dropdown'
    elsif current_page?(new_session_path)
      ""
    else
      link_to "Log in", new_session_path, class:"text-slate-800 hover:text-slate-500"
    end
  end

  def store_location
    session[:intended_url] = request.original_url if request.get?
  end

end
