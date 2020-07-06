module ApplicationHelper
  # For breadcrumbs
  def ensure_navigation
    @navigation ||= [ { :title => '首頁', :url => '/' } ]
  end

  def navigation_add(title, url)
  	ensure_navigation << { :title => title, :url => url }
  end

  def render_navigation
  	render :partial => 'layouts/navigation', :locals => { :nav => ensure_navigation }
  end

  def render_yield_rate(yield_rate)
    render :partial => 'layouts/yield_rate', locals: { yield_rate: yield_rate }
  end

  def render_up_down(ad_idx)
    render :partial => 'layouts/up_down', locals: { ad_idx: ad_idx }
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def get_config_counts(report)
    return MiReport.where('post_id = ? AND category_id = ? AND published_at = ?', 
      report.post_id, report.category_id, report.published_at).count
  end

  def get_main_mini_config_counts(report)
    return Report.where('post_id = ? AND config IN (?) AND category_name = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?', 
      report.post_id, report.config.split(';'), report.category_name, report.p_year, report.p_month, report.p_mday, report.p_hour).count
  end

  def total_yield_counts(post)
    return post.reports.where(config: 'ALL').count
  end
  
end
