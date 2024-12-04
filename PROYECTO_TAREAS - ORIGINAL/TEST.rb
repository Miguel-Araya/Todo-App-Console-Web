require_relative 'TASK.rb'
require_relative 'MENU.rb'
require_relative 'CONSOLE_CONTROLLER.rb'
require "io/console"

#@task = Task.new
@console = Console_controller.instance
@menu = Menu.new

cadena = "10.5 + 20"
expresion_regular = /\+\s\d+/

cadena = "function(argumentos, argumentos)"
expresion_regular = /(.*?)\((.*?)\)/

puts "#{cadena.match(expresion_regular).captures[0]}"

input = "Esta es una cadena de texto"

if(input.match?(/\//))

    puts "coincide"

else

    puts "no"

end