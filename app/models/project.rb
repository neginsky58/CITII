class Project < ActiveRecord::Base

    has_attached_file :picture, 
    :storage => :s3,
    :s3_credentials => { :access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'] },
    :styles => { :medium => "400x300>", :thumb => "400x300>" }, 
    :default_url => "no_image.jpg",
    :bucket => 'bidbuds'


   validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  # attr_accessor :file_file_name
  attr_accessor :picture_content_type
  attr_accessor :picture_file_size
  attr_accessor :picture_updated_at 

end
