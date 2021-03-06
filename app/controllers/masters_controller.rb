class MastersController < ApplicationController
  layout 'layouts/single_column'
  before_filter :require_login, only: [:edit, :update]

  def index
  end

  def edit
    user = @twitter_account.user
    if user.master_user.present?
      @user = user.master_user
    else
      @user = Master::User.create(user_id: user.id, total_score: 0)
    end
  end

  def update
    user = User.find(params[:user_id])
    redirect_to master_path unless user && user.master_user.present?
    master_user = user.master_user
    Master::Music.all.each do |music|
      score = Master::Score.where(
        master_user_id: master_user.id,
        master_music_id: music.id
      ).first
      score.basic_score = params[:music][music.id.to_s].to_f
      score.save
    end
    Master::Score.first.delay.update_all_scores
    Game.all.each do |game|
      game.touch
    end
    redirect_to master_path
  end

  def load_users
    respond_to { |format| format.js }
  end

  private
  def require_login
    redirect_to root_url unless @twitter_account && @twitter_account.user.present?
  end
end
