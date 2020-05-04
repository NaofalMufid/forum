class ForumThreadsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
    def index
        if  params[:search]
            @threads = ForumThread.where('title like ?', "%#{params[:search]}%")
        else
            @threads = ForumThread.order(sticky_order: :asc).order(id: :desc)
        end
        @threads = @threads.paginate(per_page: 5, page: params[:page])
    end
    
    def show
        @thread = ForumThread.friendly.find(params[:id])
        @post = ForumPost.new
        @posts = @thread.forum_post.paginate(per_page: 3, page: params[:page])
    end
    
    def new
        @thread = ForumThread.new
    end
    
    def create
        @thread = ForumThread.new(resource_params)
        @thread.user = current_user
        if @thread.save
            # puts 'berhasil disimpan'
            redirect_to root_path
        else
            # puts @thread.errors.full_messages
            render 'new'
        end
    end

    def edit
        @thread = ForumThread.friendly.find(params[:id])
        authorize @thread
    end
    
    def update
        @thread = ForumThread.friendly.find(params[:id])
        authorize @thread
        # @thread.user = current_user
        if @thread.update(resource_params)
            # puts 'berhasil disimpan'
            redirect_to forum_thread_path(@thread)
        else
            # puts @thread.errors.full_messages
            render 'new'
        end
    end
    
    def destroy
        @thread = ForumThread.friendly.find(params[:id])
        authorize @thread
        if @thread.destroy
            redirect_to root_path, notice: 'Thread was successfully deleted.'
        else
            redirect_to root_path, notice: 'Something went wrong' 
        end
    end
    

    def pinit
        @thread = ForumThread.friendly.find(params[:id])
        @thread.pinit!
        redirect_to root_path
    end
    
    
    private

    def resource_params
        params.require(:forum_thread).permit(:title, :content)
    end
    
end