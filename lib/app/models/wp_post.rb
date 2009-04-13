class WpPost < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql",
    :host     => "localhost",
    :username => "root",
    :password => "",
    :database => "imesmes_wp"
  )
  set_table_name "wp_posts"

  def self.find_last_posts(number=5)
    find_all_by_post_type('post', :limit => number)
  end
end 