class WebpagesController < ApplicationController
  def index
    @webpages = Webpage.all
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

  # def hide
  #   @webpage = Webpage.find(params[:id])
  #   @webpage.update(hidden: true)
  #   @webpage.save
  # end

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
