module AdminCrudConcern
  extend ActiveSupport::Concern

  included do
    helper_method :create_helper, :update_helper, :destroy_helper, :index_helper
  end

  def index_helper(object, options = {})
    page_size = Rails.application.config.page_size
    @objects = object.singularize.camelize.constantize.order(created_at: :desc).paginate(:page => params[:page], :per_page => page_size)
  end

  def update_helper(object, path, params)
    if object.update(params)
      respond_to do |format|
        format.html {
          redirect_to send(path, object)
          flash[:primary] = "Well done!"
        }
      end
    else
      render :edit
      flash[:danger] = "Something's not quite right"
    end
  end

  def create_helper(object, path)
    begin
      if object.save
        respond_to do |format|
          format.html {
            redirect_to send(path, object)
            flash[:primary] = "Well done!"
          }
        end
      else
        render :new
        flash[:danger] = "Something not quite right"
      end
    rescue => e
      render :new
      flash[:danger] = e.message
    end
  end

  def destroy_helper(object, path)
    begin
      if object.destroy
        respond_to do |format|
          format.html {
            redirect_to send(path)
            flash[:primary] = "Well done"    
          }
        end
      else
        render :index
        flash[:danger] = "Something's not quite right"
      end
    rescue ActiveRecord::InvalidForeignKey => e
    # Flash and render, render API json error... whatever
    # Possible error output:
    # Can't delete! PG::ForeignKeyViolation: ERROR: update or delete on table "labels" violates 
    # foreign key constraint "fk_rails_5a55c39b94" on table "products" DETAIL: Key (id)=(2) is 
    # still referenced from table "products". : DELETE FROM "labels" WHERE "labels"."id" = $1

      begin
        redirect_to send(path)
        # redirect_to send(path)
        matched = /(?<=from table)(.*?)(?=\.)/.match(e.message)
        array_of_record_ids = error_record_lookup(matched[0], object)
        flash[:danger] = "Can't delete record because #{object.class.name.downcase} with id #{object.id} is referenced in table #{matched[0]}, records with id(s) - #{array_of_record_ids}"
      rescue
        redirect_to send(path)
        flash[:danger] = "#{e.message}"
      end
    end
  end

  def error_record_lookup(class_as_string, object_as_instance_variable)
    # We receive class name as downcase string
    # "products".singularize.capitalize.constantize
    class_as_string.tr('^A-Za-z', '').singularize.capitalize.constantize.where("#{object_as_instance_variable.class.name.downcase}_id = ?", object_as_instance_variable.id).map{ |item| item.id}
    # this returns an array of all records where intial record is mentioned
  end
end