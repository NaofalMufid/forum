class ForumPostsController < ApplicationController
    before_action :authenticate_user!, only: [:create]
    def create
        @thread = ForumThread.friendly.find(params[:forum_thread_id])
        @post = ForumPost.new(resource_params)

        @post.forum_thread = @thread
        @post.user = current_user
        if @post.save
        #   flash[:success] = "post successfully created"
            redirect_to forum_thread_path(@thread)
        else
        #   flash[:error] = "Something went wrong"
            render 'forum_threads/show'
        end
    end
    
    private

    def resource_params
        params.require(:forum_post).permit(:content)
    end
    
end