require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
      u = User.create!(:name =>"Marc Meyer",
                 :email => "marc@marcmeyer.com",
                 :password =>"demodemo",
                 :password_confirmation => "demodemo")

    u.toggle!(:admin)
    User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    password = "password"
    5.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"

      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    94.times do |n|
      User.create(:name => (name=Faker::Name.name),
                  :email => Faker::Internet.email(name),
                  :password => password,
                  :password_confirmation => password)
    end
end

def make_microposts
    User.all(:limit => 6).each do  |user|
        50.times do
          user.microposts.create(:content => Faker::Lorem.sentence(5))
        end
    end
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |f|
    user.follow!(f)
  }
  followers.each {|f|
    f.follow!(user)
  }
end