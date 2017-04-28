class Admin::IgramsController < AdminController

	before_action :find_igram, only: [:edit, :update, :destroy]

	after_filter :get_instagram_data, only: [:create, :update]

  def index
  	@igrams = Igram.all
  end

  def show

  end

  def destroy
    if @igram.destroy
      
      redirect_to admin_igrams_path
      flash[:alert] = 'Удалено успешно'
    else
      render 'index'
    end
  end

  def edit

  end

  def update
  	if @igram.update(igram_params)
  		redirect_to edit_admin_igram_path(@igram)
		  flash[:success] = "Успешно обновлено"
  	else
  		render 'edit'
  	end

  end

  def new
  	@igram = Igram.new
  end

  def create 
  	@igram = Igram.new(igram_params)
  	if @igram.save
  		  redirect_to admin_igrams_path
        flash[:success] = "Успешно создано"
    else
      render 'new'
  	end
  end

  private

  def find_igram
  	@igram = Igram.find(params[:id])
  end

  def igram_params
  	params.require(:igram).permit(:url, :author, :description, :thumb_image, :src_image, :comments, :likes, :userpic)
  end

  def get_instagram_data
  	url = "#{@igram.url}?__a=1"
  	doc = Nokogiri::HTML(open(url))
  	instagram_data = JSON.parse(doc)

  	author = instagram_data["media"]["owner"]["username"]
  	
    # description = instagram_data["media"]["caption"]
    # Changed as of 27/04/2017 because of internal Instagram changes
    description = instagram_data["graphql"]["shortcode_media"]["edge_media_to_caption"]["edges"][0]["node"]["text"]
  	likes = instagram_data["media"]["likes"]["count"]
  	comments = instagram_data["media"]["comments"]["count"]
  	@igram.remote_src_image_url = instagram_data["graphql"]["shortcode_media"]["display_url"]
  	@igram.remote_userpic_url = instagram_data["media"]["owner"]["profile_pic_url"]
  	
  	@igram.update(author: author, description: description, likes: likes, comments: comments)
  end
end
