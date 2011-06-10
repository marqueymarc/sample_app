Factory.define :user do |user|
  user.name "Marc 2 Meyer"
  user.email "cramulous@marcmeyer.com"
  user.password "againand"
  user.password_confirmation "againand"
end
Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
Factory.define :micropost do |m|
  m.content "default micropost test"
  m.association :user
end