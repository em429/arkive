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
    begin
      @webpage = Webpage.new(webpage_params)

      # Save to database
      if @webpage.save
        Thread.new do
          Rails.application.executor.wrap do
            # Save to Internet Archive
            uri = URI('https://web.archive.org/save')
            res = Net::HTTP.post_form(uri, :url => @webpage.url, :capture_all => 'on')
            @webpage.update(internet_archive_url: "https://web.archive.org/web/" + @webpage.url)

            # Extract primary readable content and add it to db
            source = open(@webpage.url).read
            @webpage.update(content: Readability::Document.new(source).content)
          end
        end
        
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => error
      puts 'exception!'
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

    if request.referrer == request.base_url + "/"
      redirect_to root_path 
    elsif request.referrer == request.base_url + "/show_read"
      redirect_to show_read_path
    else
      redirect_to @webpage
    end
  end

  def destroy
    @webpage = Webpage.find(params[:id])
    @webpage.destroy

    redirect_to root_path, status: :see_other, notice: "Webpage successfully deleted from archive."

    # redirect_to root_path, status: :see_other
  end

  private
  	def webpage_params
    	params.require(:webpage).permit(:title, :url, :internet_archive_url)
  	end

end
