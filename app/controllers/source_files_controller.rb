class SourceFilesController < ApplicationController
  def index
    @post = Post.find_by_slug(params[:post_id])
    page = (params[:page] || 1).to_i
    @files = @post.source_files.order("published_at DESC").page(params[:page]).per(100)
  end

  def show
    @post = Post.find(params[:post_id])
    @file = @post.source_files.find_by_id(params[:id])
    if @file
      if @file.file_name.include? "MI-INDEX"
        @category_id = @file.file_name[9, 2].to_i
        @reports = @post.mi_reports.where(category_id: @category_id, yield_file_id: @file).order("category_id ASC").page(params[:page]).per(100)
      else
        @reports = @post.reports.where(yield_file_id: @file).order("category_id ASC").page(params[:page])
      end
    end
  end

  def destroy
    @post = Post.find_by_slug(params[:post_id])
    @file = @post.source_files.find(params[:id])
    @file.destroy
    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to post_path(@post), notice: "文件 '#{@file.file_name}' 已成功刪除" }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    @post = Post.find_by_slug(params[:post_id])
    if params[:file_ids]
      SourceFile.where(id: params[:file_ids]).destroy_all
      
      respond_to do |format|
        format.js { head :ok }
        format.html { redirect_to post_source_files_path(@post), notice: "已成功刪除 #{params[:file_ids].count} 個文件" }
        format.json { head :no_content }
      end
    end
  end
end
