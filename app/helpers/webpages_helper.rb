module WebpagesHelper

  def toggle_read_status_icon(webpage)
    if webpage.status_read?
      link_to webpage_status_path(webpage),
        class: "inline-block hover:text-slate-500 text-slate-300",
        data: { turbo_method: :patch, turbo_params: { status: Webpage.statuses[:read] } } do
          render 'svgs/check-badge' 
      end
    else
      link_to webpage_status_path(webpage),
        class: "inline-block hover:text-slate-300 text-slate-500",
        data: { turbo_method: :patch, turbo_params: { status: Webpage.statuses[:read] } } do
          render 'svgs/check-badge'
      end
    end
  end

  def toggle_read_status_button(webpage)
    if webpage.status_read?
      button_to 'Mark Unread', webpage_status_path(webpage),
        method: :patch, params: { status: Webpage.statuses[:unread] },
        class: 'btn-primary'
    else
      button_to 'Mark Read', webpage_status_path(webpage),
        method: :patch, params: { status: Webpage.statuses[:read] },
        class: 'btn-primary'
    end
  end

  
end
