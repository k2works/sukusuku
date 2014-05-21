class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :inside
  ]

  def home
    @entry = Entry.new
  end

  def inside
  end

  def entry
    @entry = Entry.new(entry_params)

    if @entry.save
      redirect_to home_path, notice: "登録ありがとうございます。"
    else
      flash[:alert] = "#{@entry.errors.full_messages[0]}"
      render 'home'
    end
  end

  private
  def entry_params
    params.require(:entry).permit(:email)
  end

end
