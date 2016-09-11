class Admin::EmployeesController < AdminController
	
	before_action :find_employee, only: [:edit, :update]

	def index
		@employees = Employee.all
	end

	def new
		@employee = Employee.new
	end

	def create
		@employee = Employee.new(employee_params)

		if @employee.save
  			redirect_to admin_employees_path, method: :get
      		flash[:success] = "Успешно создано"
  		else
  			render 'new'
  		end
	end

	def edit
	end

	def update
		if @employee.update(employee_params)
			redirect_to edit_admin_employee_path(@employee), method: :get
			flash[:success] = "Успешно обновлено"
		else
			render "edit"
		end
	end


	private

	def find_employee
		@employee = Employee.find(params[:id])
	end

	def employee_params
		params.require(:employee).permit(:name, :description, :image, :jobtitle_id, :remove_image)
	end
end
