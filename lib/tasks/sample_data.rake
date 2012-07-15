namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    
    ###
    # USERS/CHILDREN
    ###
    
    # Admin
    user = User.create!(
      :email => 'admin@gmail.com', 
      :password => 'password', 
      :password_confirmation => 'password'
    )
    user.add_role :admin
    user.add_role :teacher
    
    # Teachers
    2.times do |n|
      email = "teacher-#{n+1}@gmail.com"
      password  = "password"
      user = User.create!(:email => email,
                          :password => password,
                          :password_confirmation => password)
      user.add_role :teacher
    end
    
    # Parents/Children/Routines
    ## child vars
    nc_options = [1,2,3]  # nc = num children
    ## routine vars
    year = Time.now.year
    month = Time.now.month
    day_options = (1..30).to_a
    subject_options = ["Art", "Cognitive Development", "Language", "Math", 
                       "Motor Skills", "Music", "Science", 
                       "Social & Emotional Development"]
    sentence_options = (1..5).to_a
    6.times do |n|
      email = "parent-#{n+1}@gmail.com"
      password  = "password"
      user = User.create!(:email => email,
                          :password => password,
                          :password_confirmation => password)
      user.add_role :parent
      
      # Children/Routines
      nc = nc_options.sample()
      nc.times do |nn|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        child = user.children.create!(
          :first_name => first_name, 
          :last_name => last_name
        )
        
        # Routines
        99.times do |nnn|
          starts_at = Time.local(year, month, day_options.sample())
          ends_at = starts_at + 1.day - 1.minute
          all_day = true
          title = subject_options.sample()
          description = Faker::Lorem.sentences(sentence_options.sample())
          child.routines.create!(
            :starts_at => starts_at, 
            :ends_at => ends_at, 
            :all_day => all_day, 
            :title => title, 
            :description => description
          )
        end
      end
    end
  end
end
