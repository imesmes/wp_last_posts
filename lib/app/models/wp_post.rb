class WpPost < ActiveRecord::Base
  establish_connection YAML.load_file "#{RAILS_ROOT}/vendor/plugins/wp_last_posts/lib/db_config.yml"
  set_table_name 'wp_posts'

  def self.find_last_posts(number=2)
    last_posts = find_all_by_post_type_and_post_status('post', 'publish', :order => 'post_date DESC', :limit => number)
    languages = YAML.load_file "#{RAILS_ROOT}/vendor/plugins/wp_last_posts/lib/qlanguages.yml"
    languages = languages["languages"].split ','

    last_posts.each do |p|
      content=p.post_content.split '<!--:-->'
      post_content = {}

      content.each do |c|
        languages.each do |l|
          aux = c.split "<!--:#{l}-->"
          if aux.size > 1
            post_content.merge! l.to_sym => aux[1]
          end
        end
      end    
      p.post_content = post_content
      
      title=p.post_title.split '<!--:-->'
      post_title = {}

      title.each do |t|
        languages.each do |l|
          aux = t.split "<!--:#{l}-->"
          if aux.size > 1
            post_title.merge! l.to_sym => aux[1]
          end
        end
      end    
      p.post_title = post_title
    end

    Rails.cache.write('wordpress', last_posts)
  end
  
end

