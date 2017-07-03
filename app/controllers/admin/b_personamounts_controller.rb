class Admin::BPersonamountsController < AdminController
  before_action :find_b_personamount, only: [:edit, :update, :destroy]
  

  def new
    @b_personamount = BPersonamount.new
    @b_personamount.dinner_amount_options.build
  end

  def index
    @b_personamounts = BPersonamount.order(created_at: :desc)
  end

  def edit
    if @b_personamount.dinner_amount_options.blank?
      @b_personamount.dinner_amount_options.build
    end
  end

  def destroy
      if @b_personamount.destroy
          redirect_to admin_b_personamounts_path
          flash[:alert] = 'Удалено успешно'
      else
          render 'index'
      end
  end

  def create
    @b_personamount = BPersonamount.new(b_personamount_params)

    if @b_personamount.save
      redirect_to admin_b_personamounts_path
      flash[:success] = "Успешно создано"
    else
      @b_personamount.errors.full_messages.each do |message| 
          flash[:danger] = message
        end
        render 'new'
      end
  end

  def update

    if @b_personamount.update(b_personamount_params)
      redirect_to edit_admin_b_personamount_path(@b_personamount)
      flash[:success] = "Успешно обновлено"
    else
      @b_personamount.errors.full_messages.each do |message| 
          flash[:danger] = message
        end
        render 'edit'
      end
  end

  private


  def b_personamount_params
    params.require(:b_personamount).permit(:value, :wordvalue, :pricechange, :title, :pricechange_life, :sortable,
      dinner_amount_options_attributes: [:day_number, :pricechange, :b_personamount_id, :id, :_destroy])
  end

  def find_b_personamount
    @b_personamount = BPersonamount.find(params[:id])
  end
end
