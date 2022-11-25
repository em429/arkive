class WebpagesController < ApplicationController
  def index
    @webpages = Webpage.where(read_status: false)
  end

  def show_read
    @webpages = Webpage.all
    render "index"
  end

  def show
    @webpage = Webpage.find(params[:id])
  end

  def new
    @webpage = Webpage.new
  end

  def create
    @webpage = Webpage.new(webpage_params)

    if @webpage.save
      uri = URI('https://web.archive.org/save')
      res = Net::HTTP.post_form(uri, :url => @webpage.url, :capture_all => 'on')
      @webpage.update(internet_archive_url: "https://web.archive.org/web/" + @webpage.url)
      
      redirect_to @webpage
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @webpage = Webpage.find(params[:id])
  end

  def update
    @webpage = Webpage.find(params[:id])

    if @webpage.update(webpage_params)
      redirect_to @webpage
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_read_status
    @webpage = Webpage.find(params[:id])
    if @webpage.read_status
      @webpage.update(read_status: false)
    else
      @webpage.update(read_status: true)
    end
    
    redirect_to @webpage
  end


  def destroy
    @webpage = Webpage.find(params[:id])
    @webpage.destroy

    redirect_to root_path, status: :see_other
  end

  private
  	def webpage_params
    	params.require(:webpage).permit(:title, :url, :internet_archive_url)
  	end

end
