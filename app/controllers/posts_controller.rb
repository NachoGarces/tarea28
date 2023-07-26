class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    idpost = params[:id]
    @comentarios = Comentario.where(post_id: idpost)

    if current_user != nil 
      @comentario = Comentario.new
      @comentario.user_id = current_user.id
      @comentario.post_id = idpost
      if @comentario.texto != nil
        @comentario.save
      end
    else
      redirect_to new_user_session_path
    end
  end

  # GET /posts/new
  def new
    if current_user.id == 1
      @post = Post.new
    elsif current_user == nil
      redirect_to new_user_session_path
    else
      format.html { redirect_to posts_path, notice: "Solo Kari puede subir imagenes" }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    if current_user.id == 1
      @post = Post.new(post_params)
      @post.user_id = 1

      respond_to do |format|
        if @post.save
          format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      format.html { redirect_to posts_path, notice: "Solo Kari puede subir imagenes" }
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:foto, :user_id)
    end

    def comentario_params
      params.require(:comentario).permit(:user_id, :post_id, :texto)
    end
end
