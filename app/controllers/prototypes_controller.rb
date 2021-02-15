class PrototypesController < ApplicationController

  before_action :set_prototype, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    # binding.pry
    # createアクションにデータ保存のための記述をし、保存されたときはルートパスに戻るような記述をした
    # createアクションに、データが保存されなかったときは新規投稿ページへ戻るようrenderを用いて記述した
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    # showアクションにインスタンス変数@prototypeを定義した。且つ、Pathパラメータで送信されるID値で、Prototypeモデルの特定のオブジェクトを取得するように記述し、それを@prototypeに代入した
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
    # binding.pry
  end

  def edit
    # editアクションにインスタンス変数@prototypeを定義した。且つ、Pathパラメータで送信されるID値で、Prototypeモデルの特定のオブジェクトを取得するように記述し、それを@prototypeに代入した
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id
      render :index
    end
  end

  def update
    # updateアクションにデータを更新する記述をし、更新されたときはそのプロトタイプの詳細ページに戻るような記述をした
    # updateアクションに、データが更新されなかったときは、編集ページに戻るようにrenderを用いて記述した
    prototype = Prototype.find(params[:id])
    # binding.pry
    if prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find_by(params[:id])
    if prototype.destroy
      redirect_to root_path
    end
  end

private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def contributor_confirmation
    # redirect_to root_path unless current_user == @prototype.user
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
