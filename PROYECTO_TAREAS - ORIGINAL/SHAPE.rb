require_relative "CONSOLE_CONTROLLER.rb"

class Shape

  @@console = Console_controller.instance

  def down_arrow(width, height, left_num)
    print @@console.get_color("CYAN")

    left_content = "#{@@console.get_space}"
    left_num.times do
      left_content += " "
    end

    print left_content + " _"

    width_draw = width - 2

    width_draw.times do
      print left_content + "_"
    end

    print "_ "

    puts ""

    height.times do
      print left_content + "|"
      width.times do
        print " "
      end
      print "|"

      puts ""
    end

    index_left = 0
    width_arrow = width + 2
    index_right = width + 1

    width.times do
      width_arrow.times do |j|
        case j
        when index_left
          print left_content + "\\"
        when index_right
          print "/"
        else
          print " "
        end
      end
      puts ""
      index_left += 1
      index_right -= 1
    end

    puts @@console.get_color("DEFAULT")
  end

  def right_arrow(height, message, num_task)
    print @@console.get_color("WHITE")
  
    height.times do
      print ">"
    end
  
    print " #{num_task}"
    
    puts "#{@@console.get_color("CYAN")} #{message}"
    print @@console.get_color("WHITE")
  
    print @@console.get_color("DEFAULT")
  
    puts ""
  end
  
  def mark_task(task)
    #check = "\u2713"
    puts "#{@@console.get_bg_color("GREEN")}#{@@console.get_color("BLACK")}✓#{@@console.get_bg_color("DEFAULT")} #{task}"
    puts ""
  end
  
  def unmark_task(task)

    puts "#{@@console.get_bg_color("RED")}#{@@console.get_color("BLACK")}X#{@@console.get_bg_color("DEFAULT")} #{task}"
    puts ""

  end
 
  def get_max_length_menu_option(menu_option)
    max = 0

    menu_option.each do |option|
      if max < option.length
        max = option.length
      end
    end

    return max
  end

  #box_style
  #solid, dotted, dashed
  #bubble, diamond, 
  def draw_box_menu(menu_option, option, box_style = "solid" , box_color = "WHITE", text_color = "CYAN", type_icon = "default")

    box_style ||= "solid"
    box_color ||= "WHITE"
    text_color ||= "CYAN"
    type_icon ||= "default"

    exception_style = ["solid", "dashed"]

    if exception_style.include?(box_style)

      send("box_menu_#{box_style}", menu_option, option, box_color, text_color, @@console.get_selected_icon(type_icon))

    else

      send("box_menu_decoration", menu_option, option, box_color, text_color, @@console.get_decoration_style(box_style), @@console.get_selected_icon(type_icon))

    end

  end

  #box_color, text_color
  def box_menu_solid(menu_option, option, box_color, text_color, selected_icon)

    max_option = get_max_length_menu_option(menu_option)

    #draw the principal menu box
    horizontal_bar = "#{@@console.get_space}"
    horizontal_bar_space = "#{@@console.get_space}#{@@console.get_bg_color("#{box_color}")}  #{@@console.get_bg_color("DEFAULT")}"

    # the + 7 is for, 6 for 2 to form the first block, 2 to from the last block to close the box menu
    # 2 for the block of the selected option and 1 for the space between the option and the beginning
    # of the box menu
    (max_option + 8).times do
      horizontal_bar += "#{@@console.get_bg_color("#{box_color}")} #{@@console.get_bg_color("DEFAULT")}"
    end

    # adding 3 for, 1 for the space begging of the option, 1 for the space with the selected option and 1 space for a space between
    # the simbol selected and the box menu
    (max_option + 4).times do
      horizontal_bar_space += " "
    end

    horizontal_bar_space += "#{@@console.get_bg_color("#{box_color}")}  #{@@console.get_bg_color("DEFAULT")}"

    @@console.apply_margin

    puts horizontal_bar
    puts horizontal_bar_space

    menu_option.size.times do |index|
      if option == index
        print_option = "#{@@console.get_space}#{@@console.get_bg_color("#{box_color}")}  #{@@console.get_bg_color(
        "DEFAULT")}#{@@console.get_color("#{text_color}")} #{menu_option[index]} #{selected_icon}#{@@console.get_color("DEFAULT")}"
          
        # the +1 is for the space between the selected simbol
        size_box_menu = (max_option - menu_option[index].length) +1

        size_box_menu.times do
          print_option += " "
        end
        print_option += "#{@@console.get_bg_color("#{box_color}")} #{@@console.get_bg_color("DEFAULT")}"
        print_option += "#{@@console.get_bg_color("#{box_color}")} #{@@console.get_bg_color("DEFAULT")}"

        puts print_option
      else
        print_option = "#{@@console.get_space}#{@@console.get_bg_color("#{box_color}")}  #{@@console.get_bg_color(
          "DEFAULT"
        )} #{menu_option[index]}"

        # the +2 is for, 1 for filled the space of the not selected option, and 1 for the space between the option and the box menu
        #and +1 between the right position of the icon and the selected icon
        size_box_menu = (max_option - menu_option[index].length) + 3

        size_box_menu.times do
          print_option += " "
        end

        print_option += "#{@@console.get_bg_color("#{box_color}")} #{@@console.get_bg_color("DEFAULT")}"
        print_option += "#{@@console.get_bg_color("#{box_color}")} #{@@console.get_bg_color("DEFAULT")}"

        puts print_option

      end
    end

    puts horizontal_bar_space
    puts horizontal_bar

  end
  
  def box_menu_dashed(menu_option, option, box_color, text_color, selected_icon)

    selected_option = "<"
    max_option = get_max_length_menu_option(menu_option)

    #draw the principal menu box
    horizontal_bar = " #{@@console.get_space}"
    horizontal_bar_space = "#{@@console.get_space}#{@@console.get_color("#{box_color}")}| #{@@console.get_color("DEFAULT")}"


    # the + 7 is for, 6 for 2 to form the first block, 2 to from the last block to close the box menu
    # 2 for the block of the selected option and 1 for the space between the option and the beginning
    # of the box menu
    (max_option + 6).times do
      horizontal_bar += "#{@@console.get_color("#{box_color}")}-#{@@console.get_color("DEFAULT")}"
    end

    # adding 3 for, 1 for the space begging of the option, 1 for the space with the selected option and 1 space for a space between
    # the simbol selected and the box menu
    (max_option + 4).times do
      horizontal_bar_space += " "
    end

    horizontal_bar_space += "#{@@console.get_color("#{box_color}")} |#{@@console.get_color("DEFAULT")}"

    @@console.apply_margin

    puts "#{horizontal_bar}"
    puts "#{horizontal_bar_space}#{@@console.get_color("#{box_color}")}\\#{@@console.get_color("DEFAULT")}"

    menu_option.size.times do |index|
      if option == index
        print_option = "#{@@console.get_space}#{@@console.get_color("#{box_color}")}| #{@@console.get_color(
        "DEFAULT")}#{@@console.get_color("#{text_color}")} #{menu_option[index]} #{selected_icon}#{@@console.get_color("DEFAULT")}"
          
        # the +1 is for the space between the selected simbol
        size_box_menu = (max_option - menu_option[index].length) + 1

        size_box_menu.times do
          print_option += " "
        end
        print_option += "#{@@console.get_color("#{box_color}")} |#{@@console.get_color("DEFAULT")}"
        print_option += "#{@@console.get_color("#{box_color}")} |#{@@console.get_color("DEFAULT")}"

        puts print_option
      else
        print_option = "#{@@console.get_space}#{@@console.get_color("#{box_color}")}| #{@@console.get_color(
          "DEFAULT"
        )} #{menu_option[index]}"

        # the +2 is for, 1 for filled the space of the not selected option, and 1 for the space between the option and the box menu
        size_box_menu = (max_option - menu_option[index].length) + 3

        size_box_menu.times do
          print_option += " "
        end

        print_option += "#{@@console.get_color("#{box_color}")} |#{@@console.get_color("DEFAULT")}"
        print_option += "#{@@console.get_color("#{box_color}")} |#{@@console.get_color("DEFAULT")}"

        puts print_option

      end
    end

    puts "#{horizontal_bar_space}#{@@console.get_color("#{box_color}")}/#{@@console.get_color("DEFAULT")}"
    puts horizontal_bar
  end

  def box_menu_decoration(menu_option, option, box_color, text_color, decoration_symbol, selected_icon)

    selected_option = "<"
    max_option = get_max_length_menu_option(menu_option)

    #draw the principal menu box
    horizontal_bar = "#{@@console.get_space}"
    horizontal_bar_space = "#{@@console.get_space}#{@@console.get_color("#{box_color}")}#{decoration_symbol} #{@@console.get_color("DEFAULT")}"

    # the + 7 is for, 6 for 2 to form the first block, 2 to from the last block to close the box menu
    # 2 for the block of the selected option and 1 for the space between the option and the beginning
    # of the box menu
    (max_option + 8).times do
      horizontal_bar += "#{@@console.get_color("#{box_color}")}#{decoration_symbol}#{@@console.get_color("DEFAULT")}"
    end

    # adding 3 for, 1 for the space begging of the option, 1 for the space with the selected option and 1 space for a space between
    # the simbol selected and the box menu
    (max_option + 4).times do
      horizontal_bar_space += " "
    end

    horizontal_bar_space += "#{@@console.get_color("#{box_color}")} #{decoration_symbol}#{@@console.get_color("DEFAULT")}"

    @@console.apply_margin

    puts "#{horizontal_bar}"
    puts "#{horizontal_bar_space}"

    menu_option.size.times do |index|
      if option == index
        print_option = "#{@@console.get_space}#{@@console.get_color("#{box_color}")}#{decoration_symbol} #{@@console.get_color(
        "DEFAULT")}#{@@console.get_color("#{text_color}")} #{menu_option[index]} #{selected_icon}#{@@console.get_color("DEFAULT")}"
          
        # the +1 is for the space between the selected simbol
        size_box_menu = (max_option - menu_option[index].length) + 1

        size_box_menu.times do
          print_option += " "
        end
        print_option += "#{@@console.get_color("#{box_color}")} #{decoration_symbol}#{@@console.get_color("DEFAULT")}"
        
        puts print_option
      else
        print_option = "#{@@console.get_space}#{@@console.get_color("#{box_color}")}#{decoration_symbol} #{@@console.get_color(
          "DEFAULT"
        )} #{menu_option[index]}"

        # the +2 is for, 1 for filled the space of the not selected option, and 1 for the space between the option and the box menu
        size_box_menu = (max_option - menu_option[index].length) + 3

        size_box_menu.times do
          print_option += " "
        end

        print_option += "#{@@console.get_color("#{box_color}")} #{decoration_symbol}#{@@console.get_color("DEFAULT")}"
        
        puts print_option

      end
    end

    puts "#{horizontal_bar_space}"
    puts "#{horizontal_bar}"

  end

end