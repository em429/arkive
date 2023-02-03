module WebpagesHelper

  def toggle_read_status_icon(webpage)
    if webpage.read_status?
      link_to mark_unread_path(current_user, webpage),
      class: "inline-block hover:text-slate-500 text-slate-300" do
        render 'svgs/check-badge' 
      end
    else
      link_to mark_read_path(current_user, webpage),
      class: "inline-block hover:text-slate-300 text-slate-500" do
        render 'svgs/check-badge'
      end
    end
  end

  def toggle_read_status_button(webpage)
    if webpage.read_status?
      link_to 'Mark Unread', mark_unread_path(current_user, webpage), class: 'btn-primary'
    else
      link_to 'Mark Read', mark_read_path(current_user, webpage), class: 'btn-primary'
    end
  end

  
end
