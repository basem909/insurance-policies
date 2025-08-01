class PoliciesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @policies = @policies.order(start_date: :desc)
  end

  def show; end

  def new; end

  def create
    if @policy.save
      redirect_to @policy, notice: "Policy created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @policy.update(policy_params)
      redirect_to @policy, notice: "Policy updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @policy.destroy
    redirect_to policies_path, notice: "Policy deleted."
  end

  private

    def policy_params
      params.require(:policy)
            .permit(:policy_number, :user_id, :start_date, :end_date, :status)
    end
end
