class WpPost < ActiveRecord::Base
  establish_connection YAML.load_file "#{RAILS_ROOT}/vendor/plugins/wp_last_posts/lib/db_config.yml"
  set_table_name 'wp_posts'

  def self.find_last_posts(number=2)
    last_posts = find_all_by_post_type_and_post_status('post', 'publish', :order => 'post_date DESC', :limit => number)
    
    last_posts.each do |p|
      content=p.post_content.split '<!--:-->'
      post_content = {}

      content.each do |c|
        aux = c.split '<!--:ca-->'
        if aux.size > 1
          post_content.merge! :ca => aux[1]
        else
          aux = c.split '<!--:es-->'
          if aux.size > 1
            post_content.merge! :es => aux[1]
          else
            aux = c.split '<!--:en-->'
            if aux.size > 1
              post_content.merge! :en => aux[1]
            end
          end
        end
      end    
      p.post_content = post_content
      
      title=p.post_title.split '<!--:-->'
      post_title = {}

      title.each do |t|
        aux = t.split '<!--:ca-->'
        if aux.size > 1
          post_title.merge! :ca => aux[1]
        else
          aux = t.split '<!--:es-->'
          if aux.size > 1
            post_title.merge! :es => aux[1]
          else
            aux = t.split '<!--:en-->'
            if aux.size > 1
              post_title.merge!  :en => aux[1]
            end
          end
        end
      end    
      p.post_title = post_title
    end

    Rails.cache.write('wordpress', last_posts)
  end
  
end

