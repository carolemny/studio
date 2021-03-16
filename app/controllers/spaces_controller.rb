class SpacesController < ApplicationController
  before_action :set_space, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:create, :new]
  before_action :is_host?, only: [:edit, :update, :destroy]

  def index
    @spaces = Space.all
  end

  def show
  end

  def new
    @space = Space.new
  end

  def edit
  end

  def create
    @space = Space.new(space_params)
    @space.host_id = current_user.id

    respond_to do |format|
      if @space.save
        JoinSpaceCategory.create(space_id: @space.id, category_id: params["Catégorie"])
        format.html { redirect_to @space, notice: "Votre local a bien été créé. " }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @space.update(space_params)
        format.html { redirect_to @space, notice: "Votre local a bien été mis à jour. " }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @space.destroy
    respond_to do |format|
      format.html { redirect_to spaces_url, notice: "Votre local a bien été supprimé. " }
      format.json { head :no_content }
    end
  end

  private

  def set_space
    @space = Space.find(params[:id])
  end

  def space_params
    params.require(:space).permit(:description, :zip_code, :address, :city, :host_id)
  end

  def is_host?
    @space = set_space
    unless @space.host_id == current_user.id
      flash[:danger] = "Vous n'êtes pas autorisé à modifier cet espace."
      redirect_to root_path
    end
  end
end
