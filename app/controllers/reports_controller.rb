class ReportsController < ApplicationController
  def show
    page = (params[:page] || 1).to_i
  	@post = Post.find_by_slug(params[:post_id])
    @report = @post.reports.find(params[:id])
    @category = @report.category
    @reports_for_cart = @post.mi_reports.where('category_id = ? AND published_at = ?', 
    	@report.category_id, @report.published_at).order("published_at DESC")
  	@reports = @reports_for_cart.page(page)
  end

  def search
    @posts = Post.all
    @post = Post.find_by_slug(params[:post_id]) if params[:post_id]
    @category = @post.categories.find_by_id(params[:category]["id"]) if params[:category]
    page = (params[:page] || 1).to_i

    # For rendering contents by click tab after search
    if params[:from_category]
      @category = @post.categories.find(params[:from_category])
      reports_by_all_config = @category.reports.where(config: 'ALL')
    elsif params[:from_report] && params[:show_config] == 'all'
      @report = @post.reports.find(params[:from_report])
      @category = @report.category
      @reports_for_cart = @post.reports.where('config != ? AND category_name = ? AND published_at = ?', 
        'ALL', @report.category_name, @report.published_at).order("published_at DESC")
      @reports = @reports_for_cart.page(page)
    else
      if params[:post_id]
        reports_by_all_config = @post.reports.where(config: 'ALL')
      end
    end

    if params[:date].present? && params[:date] == 'today'
      if @post.reports.count == 0
        redirect_to post_path(@post), alert: "抱歉，沒有資料！"
        return
      else
        redirect_to post_path(@post)
      end
    elsif params[:date].present? && params[:date] == 'yesterday'
      if @post.reports.count == 0
        redirect_to post_path(@post), alert: "抱歉，沒有資料！"
        return
      else
        redirect_to post_path(@post)
      end
    elsif params[:commit] == 'Search' || params[:commit] == 'GlobalSearch'
      # For search function
      category = params[:category]
      date_from = params[:date_range][0, 10] if params[:date_range]
      date_to = params[:date_range][13, 10] if params[:date_range]
      fix_datetime = params[:no_date_range] if params[:no_date_range]

      date = params[:date] if params[:date]
      date1 = params[:date1] if params[:date1]
      date2 = params[:date2] if params[:date2]
      date3 = params[:date3] if params[:date3]
      search_type = params[:search_type] if params[:search_type]

      t = Report.arel_table
      @reports_for_cart = Report.where(post_id: @post)
      @reports_for_cart = @reports_for_cart.where(t[:category_name].matches("#{category}")) if category.present?

      # Multiple Date Search
      if date1.present? || date2.present? || date3.present? && !search_type.present?
        dates_for_filter = []
        [date1, date2, date3].each do |date|
          dates_for_filter << date if date.present?
        end
        @reports_for_cart = @reports_for_cart.where(published_at: [dates_for_filter])
        @dates_selected = @reports_for_cart.select("distinct(published_at)")
        @dates_selected_count = @dates_selected.count

        report_for_tmp = @reports_for_cart
        @reports_for_cart = report_for_tmp.order("published_at ASC")
        @distinct_date = @reports_for_cart.select("distinct(published_at)")
        
        @reports = report_for_tmp.order("category_id ASC, published_at ASC").page(page)
        @reports_summarize = @reports_for_cart.group_by(&:category_name)
      # Date Range Search
      elsif date_from.present? && date_to.present? && search_type.present? && search_type == "Range"
        if date_from != date_to # Search for multiple days (ex. Jun 20 ~ Jun 23)
          dates_for_filter = []
          search_date_range = ("#{date_from}".."#{date_to}")
          search_date_range.each do |the_date|
            dates_for_filter.append(the_date)
          end
          @reports_for_cart = @reports_for_cart.where(published_at: [dates_for_filter])
          report_for_tmp = @reports_for_cart
          @reports_for_cart = report_for_tmp.order("published_at ASC")
          @distinct_date = @reports_for_cart.select("distinct(published_at)")
          
          @reports = report_for_tmp.order("category_id ASC, published_at ASC").page(page)
          @reports_summarize = report_for_tmp.select('category_name, MAX(shares_percentage) as best_sp, MIN(shares_percentage) as worst_sp, MAX(closing_percentage) as best_cp, MIN(closing_percentage) as worst_cp').group(:category_id, :category_name)

          # Get all dates that best shares percentage occurs
          @best_sp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(category_name: item.category_name).where("shares_percentage > ? AND shares_percentage < ?", item.best_sp - 0.00001, item.best_sp + 0.00001)
            @best_sp_dates.append(matched_dates)
          end

          # Get all dates that worst shares percentage occurs
          @worst_sp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(category_name: item.category_name).where("shares_percentage > ? AND shares_percentage < ?", item.worst_sp - 0.00001, item.worst_sp + 0.00001)
            @worst_sp_dates.append(matched_dates)
          end

          # Get all dates that best closing percentage occurs
          @best_cp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(category_name: item.category_name).where("closing_percentage > ? AND closing_percentage < ?", item.best_cp - 0.00001, item.best_cp + 0.00001)
            @best_cp_dates.append(matched_dates)
          end

          # Get all dates that worst closing percentage occurs
          @worst_cp_dates = []
          @reports_summarize.each do |item|
            matched_dates = @reports_for_cart.where(category_name: item.category_name).where("closing_percentage > ? AND closing_percentage < ?", item.worst_cp - 0.00001, item.worst_cp + 0.00001)
            @worst_cp_dates.append(matched_dates)
          end
        else
          if params[:category] == ""
            latest_date = @reports_for_cart.maximum('published_at')
            @reports_for_cart = @reports_for_cart.where(published_at: latest_date)
          end
        end
      elsif date.present? && search_type.present? && search_type == "Stock"
      	@reports_for_cart = MiReport.where(post_id: @post)
        @reports_for_cart = @reports_for_cart.where(category_id: @category.id, published_at: date)
        @reports = @reports_for_cart.order("stock_code ASC").page(page)
        @distinct_date = @reports_for_cart.select("distinct(published_at)")
      end
    end
  end

end
