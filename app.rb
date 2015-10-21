require 'sinatra'
require "sinatra/reloader" if development?
require 'slim'
require 'sass'

# Компиляция файла styles.sass в style.css
get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles, :style => :compressed, :views => './public/styles'
end

# Если нужно изменить папку со статическими файлами на "assets"
# set :public, Proc.new { File.join(root, "assets") }

# Если нужно изменить папку с шаблонами на "templates"
# set :views, Proc.new { File.join(root, "templates") }

# Все шаблоны кладем в папку 'views/layouts'
set :slim, layout_options: { views: 'views/layouts' }

# Список страниц для автороутинга
set :pages, %w[index sign_in sign_out fogot]

# UI kit всех используемых элементов
get '/' do
  @title = 'UI elements'
  slim :'ui/ui'
end

# Ручной роутинг страниц, если нужны дополнительные парамеры: переменные, шаблоны
# get '/example' do
#   @title = 'Example page'
#   slim :'example/index', layout :admin
# end

# Автороутинг страниц
settings.pages.each do |page|
  get '/'+page do
    @title = page.capitalize
    slim page.to_sym, layout: (request.xhr? ? false : :layout)
  end
end

not_found do
  @title = 'Page not found'
  slim :'404'
end
