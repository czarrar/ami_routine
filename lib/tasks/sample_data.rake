namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    
    # subject
    subjects = ["Art", "Cognitive Development", "Language", "Math", 
                "Motor Skills", "Music", "Science", 
                "Social & Emotional Development"]
    subjects.each { |subject| Subject.create!(:name => subject) }
    subject_ids = Subject.all.collect { |subject| subject.id }
    
    
    ###
    # USERS/CHILDREN
    ###
    
    # Admin
    puts 'Admin'
    user = User.create!(
      :email => 'admin@gmail.com', 
      :password => 'password', 
      :password_confirmation => 'password'
    )
    user.add_role :admin
    
    # Teachers
    puts 'Teachers'
    2.times do |n|
      email = "teacher-#{n+1}@gmail.com"
      password  = "password"
      user = User.create!(:email => email,
                          :password => password,
                          :password_confirmation => password)
      user.add_role :teacher
    end
    teachers = User.joins(:roles).where("roles.name = 'teacher'")
    
    # Parents
    puts 'Parents'
    6.times do |n|
      email = "parent-#{n+1}@gmail.com"
      password  = "password"
      parent = User.create!(:email => email,
                          :password => password,
                          :password_confirmation => password)
      parent.add_role :parent      
    end
    parents = User.joins(:roles).where("roles.name = 'parent'")
    
    # Children
    puts 'Children'
    nc_options = [1,2,3]
    3.times do |i|
      ii = i*2
      ie = ii + 1
      parent_ids = parents[ii..ie].collect { |parent| parent.id }
      
      nc = nc_options.sample()
      nc.times do |nn|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        child = Child.create!(
          :first_name => first_name, 
          :last_name => last_name,
          :user_ids => parent_ids
        )
      end
    end
    child_ids = Child.all.collect { |child| child.id }
    
    # Routines
    puts 'Routines'
    year = Time.now.year
    month = Time.now.month
    day_options = (1..30).to_a
    sentence_options = (1..5).to_a
    published_options = [true, false]
    150.times do |n|
      starts_at = Time.local(year, month, day_options.sample())
      ends_at = starts_at + 1.day - 1.minute
      all_day = true
      description = Faker::Lorem.sentences(sentence_options.sample())
      teacher = teachers.sample()
      res = teacher.routines.create!(
        :child_ids => child_ids.sample(nc_options.sample()), 
        :starts_at => starts_at, 
        :ends_at => ends_at, 
        :all_day => all_day, 
        :subject_id => subject_ids.sample(), 
        :description => description,
        :published => published_options.sample()
      )
    end
    
    
  end
end
