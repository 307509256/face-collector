class InferencesController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    @inferences = Inference
      .includes(face: :photo)
      .includes(:label)
      .order(score: :desc)
      .page(params[:page])
    respond_to do |format|
      format.html { @inferences = @inferences.per(5)   }
      format.json { @inferences = @inferences.per(100) }
    end
  end

  def accept
    inference = Inference.find(params[:id])
    inference.face.update(label_id: inference.label.id, edited_user_id: current_user.id)
    inference.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { result: 'OK' } }
    end
  end
end
