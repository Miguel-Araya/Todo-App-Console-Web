require "io/console"
require_relative "./UTILITY.rb"

class Console_controller
  
  @@instance = Console_controller.new    

  private_class_method :new
  
  @@color = Utility.deep_freeze({"RED" => "\e[31m", "GREEN" => "\e[32m", "YELLOW" => "\e[33m", "BLUE" => "\e[34m", "CYAN" => "\e[36m", "WHITE" => "\e[37m" , "BLACK" => "\e[30m" ,"MAGENTA" => "\e[35m" ,"DEFAULT" => "\e[0m"})
   
  @@bg_color = Utility.deep_freeze({ "RED" => "\e[41m", "BLACK" => "\e[40m", "GREEN" => "\e[42m", "YELLOW" => "\e[43m", "BLUE" => "\e[44m", "MAGENTA" => "\e[45m", "CYAN" => "\e[46m", "WHITE" => "\e[47m" ,"DEFAULT" => "\e[0m"})

  @@input = Utility.deep_freeze({ "ARROW_UP_WINDOWS" => '"\\xE0h"', "ARROW_DOWN_WINDOWS" => '"\\xE0p"', "ARROW_LEFT_WINDOWS" => '"\\xE0k"', "ARROW_RIGHT_WINDOWS" => '"\\xE0m"', "ENTER_WINDOWS" => '""', "ARROW_UP_LINUX" => "\e[a", "ARROW_DOWN_LINUX" => "\e[b", "ARROW_RIGHT_LINUX" => "\e[c", "ARROW_LEFT_LINUX" => "\e[d", "ENTER_LINUX" => "\r"})
  
  @@utility = Utility.deep_freeze({ "CLEAN_SCREEN" => "\e[2J\e[f", "UNDERLINE" => "\e[4m", "BOLD" => "\e[1m", "DEFAULT" => "\e[0m" })
  
  @@decoration_style = Utility.deep_freeze({ "dotted" => "•", "bubble" => "○", "diamond_fill" => "◆", "diamond_empty" => "◇", "star_fill" => "★", "star_empty" => "☆"})
  
  @@selected_icon = Utility.deep_freeze({ "default" => "<", "triangle" => "◁", "square" => "☐", "double_arrow" => "«"})

  def get_color(color)
    return @@color[color]
  end
  
  def get_bg_color(bg_color)
    return @@bg_color[bg_color]
  end
 
  def get_input(input)
    return @@input[input]
  end  

  def get_decoration_style(decoration_style)

    return @@decoration_style[decoration_style]

  end

  def get_selected_icon(selected_icon)

    return @@selected_icon[selected_icon]

  end

  def get_utility(utility)
    return @@utility[utility]
  end

  def get_space
    #get the width of the window and put in the center
    space = ""
    window_center = (IO.console.winsize[1]/2.6).round
      
    window_center.times do
      space+=" "
    end

    return space

  end

  def apply_margin
    #above of the border top
    print "\n\n\n"

  end
	
  # For pagination
  def size_show_line

    #only these lines of tasks can be show at the same time in the screen

    return 7
  end
  
  def confirm_message(message)
    puts "#{get_space}#{@@color["GREEN"]}#{message}#{@@color["DEFAULT"]}"
  end
   
  def cancel_message(message)
    puts "#{get_space}#{@@color["RED"]}#{message}#{@@color["DEFAULT"]}"
  end

  def self.instance
    return @@instance
  end
  
  @@instance.freeze

end
