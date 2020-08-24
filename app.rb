# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

get '/' do
  erb 'Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>!!!'
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  @error = 'something error'
  erb :contacts
end

post '/contacts' do

  @email = params[:email]
  @message = params[:message]
  
  db = SQLite3::Database.new barbershop.sqlite
  db.execute "insert into Contacts(Email, Message) values (#{@email}, #{@message})"
  db.close

  Pony.mail(
    to: @email,
    from: 'ruby.learnmail@gmail.com',
    via: :smtp,
    body: @message,
    via_options: {
      address: 'smtp.gmail.com',
      port: 587,
      enable_starttls_auto: true,
      user_name: 'ruby.learnmail@gmail.com',
      password: '!123456Qwerasdf',
      authentication: :plain,
      domain: 'gmail.com'
                 })
end

# post '/contacts' do
#   Pony.mail(
#     to: params[:email],
#     via: :smtp,
#     body: params[:message],
#     via_options: {
#       address: 'smtp.yandex.ru',
#       port: '465',
#       enable_starttls_auto: true,
#       user_name: 'learnruby.mail@yandex.ru',
#       password: 'xbnmmlqnxpboyggk',
#       authentication: :plain}
#     )

post '/visit' do
  @master = params[:master]
  @customer_name = params[:user_name]
  @phone = params[:phone]
  @date_time = params[:date_time]
  @color = params[:color]

  # if @customer_name == ''
  #   @error = 'Введите имя'
  # end

  # if @phone == ''
  #   @error = 'Введите номер телефона'
  # end

  hh = { user_name: 'Введите имя',
         phone: 'Введите телефон',
         datetime: 'Введите дату и время' }

  # hh.each do |key, value|
  #   if params[key] == ''
  #     @error = value
  #     return erb :visit
  #   end
  # end

  #@error = hh.select { |key, _| params[key] == '' }.values.join(',')



  @error = 'Введите имя' if @customer_name == ''
  @error = 'Введите номер телефона' if @phone == ''
  @error = 'Неправильная дата и время' if @date_time == ''

  return erb :visit if @error != nil

  # file = File.open('./Public/visits.txt', 'a')
  # file.write("#{@date_time} ожидайте визита #{@customer_name} к мастеру #{@master}. Контактный телефон #{@phone}")
  # file.close

  puts 'Hey-ho'

  db = SQLite3::Database.new 'barbershop.sqlite'
  # db.execute "insert into Users(Name, Phone, DateStamp, Barber, Color) values (\"#{@customer_name}\", \"#{@phone}\", \"#{@date_time}\", \"#{@master}\", \"#{@color})\""
  db.execute 'insert into Users(Name, Phone, DateStamp, Barber, Color) values (?, ?, ?, ?, ?)', [@customer_name, @phone, @date_time, @master, @color]
  db.close

  puts 'Hey-ho'

  erb :visitsuccessful
end

# post '/contacts' do
#   @email = params[:email]
#   @message = params[:message]

#   file = File.open('./Public/contacts.txt', 'a')
#   file.write "#{@email} - #{@message}"
#   file.close

#   erb :contactadded
# end
