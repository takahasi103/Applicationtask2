class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @book = Book.new
    @groups = Group.all
  end
  
  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
  end
  
  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to groups_path
  end
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end
  
  def destroy #メンバーから削除
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end
  
  def all_destroy #グループを削除
    @group = Group.find(params[:group_id])
    @group.destroy
    redirect_to groups_path
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end
  
  def new_mail #グループメール
    @group = Group.find(params[:group_id])
  end
  
  def send_mail #送信内容を受け取りEventMailerのsend_mailアクションへ渡す
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    EventMailer.send_mail(@mail_title, @mail_content, group_users).deliver
  end
  
  private
  
  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end 
  
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end 
  end 
  
  
end
