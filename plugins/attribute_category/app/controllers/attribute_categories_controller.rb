class AttributeCategoriesController < ApplicationController

  def index
    @attribute_category = AttributeCategory.all
  end

  def show
    @attribute_category = AttributeCategory.find(params[:id])
  end

  def new
    @attribute_category = AttributeCategory.new
  end

  
  def create
    @attribute_category = AttributeCategory.new(attribute_params)

    if @attribute_category.save
      redirect_to @attribute_category
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @attribute_category = AttributeCategory.find(params[:id])
    @attribute_category.destroy

    redirect_to attribute_category_path
  end
  private
    def attribute_params
      params.require(:attribute_category).permit(:name, :description)
    end
  
end
