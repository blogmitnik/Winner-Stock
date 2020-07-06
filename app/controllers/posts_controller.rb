class PostsController < ApplicationController
  def index
    @posts = Post.all.order(:title)
    @files_count = SourceFile.all.count
  end

  def show
    page = (params[:page] || 1).to_i
    @posts = Post.all.order(:title)
    @post = Post.find_by_slug(params[:id])
    reports_by_all = @post.reports
    reports_count = @post.reports.count

    if reports_count > 0
      if params[:date] == 'today'
        if reports_count == 0
          redirect_to post_path(@post), alert: "目前沒有資料！"
          return
        else
          @reports_for_cart = get_today_yield(@post, reports_by_all)
        end
      elsif params[:date] == 'yesterday'
        if reports_count == 0
          redirect_to post_path(@post), alert: "目前沒有資料！"
          return
        else
          @reports_for_cart = get_yesterday_yield(@post, reports_by_all)
        end
      elsif params[:to_date].present? && params[:to_date] != ""
        if reports_count == 0
          redirect_to post_path(@post), alert: "目前沒有資料！"
          return
        else
          @reports_for_cart = get_custom_date_yield(@post, reports_by_all, params[:to_date])
        end
      else # Today
        @reports_for_cart = get_today_yield(@post, reports_by_all)
      end
      reports_tmp = @reports_for_cart
      @reports_for_cart = reports_tmp.order("published_at ASC")
      @reports = reports_tmp.order("category_id ASC").page(page)
    else
      respond_to do |format|
        format.js { head :ok }
        format.html { redirect_to posts_path, alert: "目前沒有資料！" }
        format.json { head :no_content }
      end
    end

  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to posts_path, notice: "#{@post.title} 的資料已經成功刪除" }
      format.json { head :no_content }
    end
  end


  protected

    def begin_of_association_chain
      current_user
    end

    def collection
      @posts ||= end_of_association_chain.order("updated_at DESC")
    end
end
