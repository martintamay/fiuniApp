class TakensController < ApplicationController
  def index
    takens = Taken.all
    render json: takens
  end

  def update
    taken = Taken.find_by_id(params[:id])
    if(taken)
      taken.update(taken_params)
      redirect_to taken_path(taken, format: :json)
    end
  end

  def create
    taken = Taken.new(career_params)
    taken.save
    redirect_to taken_path(taken, format: :json)
  end

  def show
    taken = Taken.find_by_id(params[:id])
    if(taken)
      respond_to do |format|
        format.json { render json: taken }
      end
    end
  end

  def destroy
    taken = Taken.find_by_id(params[:id])
    if(taken)
      taken.destroy
      render json: {}, status: :no_content
    end
  end

  private
    def career_params
      params.require(:taken).permit(:description)
    end
end
