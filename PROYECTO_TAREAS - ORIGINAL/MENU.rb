require "io/console"
require_relative "TASK.rb"
require_relative "SHAPE.rb"
require_relative "CONSOLE_CONTROLLER.rb"
require_relative "UTILITY.rb"

class Menu

  @@console = Console_controller.instance

  @@task = nil

  @@shape = Shape.new

  @@paths = Utility.get_json("paths.json")

  def init

    print @@console.get_utility("CLEAN_SCREEN")

    #Load the first menu to select the file that contain the tasks
    result = load_menu_file
    
    confirm_out = false
    
    if result < 0

      @@console.apply_margin
      @@console.cancel_message("No files found.\n")

      puts "#{@@console.get_space}You want to create a new file?\n\n"

      confirm_out = wait_confirm("to create the file")

      if confirm_out

        return

      end

      #The user want to create a new file

      #if not create a new file
      if !exec_create_file

        print @@console.get_utility("CLEAN_SCREEN")

        @@console.apply_margin 
        @@console.cancel_message("No file created\n")

        return 

      end

      return if load_menu_file < 0

    end

    @@console.get_utility("CLEAN_SCREEN")

    #variables to init the menu
    menu_option = []
    menu_method = []
    menu_level = 1

    principal_menu_option = ["◉ Exit", "◉ Task file ▼", "◉ Add task", "◉ Seek ▼", "◉ Delete ▼", "◉ Update", "◉ Mark as done ▼", "◉ Unmark task ▼", "◉ Status of tasks"]
    principal_menu_method = ["menu", "exec_add", "menu", "menu", "exec_update", "menu", "menu", "exec_status_task"]
    #menu_style = ["box_style" ,"box_color", "text_color", selected_icon]
    #principal_menu_style = ["dotted", "CYAN", nil, nil]

    #Start create secondMenu

    second_menu_seek = ["◌ Back", "◌ Seek specific", "◌ Seek partial"]
    second_menu_method_seek = ["exec_seek_specific", "exec_seek_partial"]
    #second_menu_seek_style = ["dotted", "GREEN", nil]

    second_menu_task_file = ["◌ Back","◌ Select file","◌ Create file", "◌ Seek file ▼", "◌ Delete file ▼"]
    second_menu_method_task_file = ["load_menu_file", "exec_create_file", "menu", "menu"]

    second_menu_delete = ["◌ Back","◌ Delete specific","◌ Delete partial","◌ Delete unmark tasks","◌ Delete mark tasks","◌ Delete a set of tasks","◌ Delete by range"]
    second_menu_method_delete = ["exec_delete_specific", "exec_delete_partial", "exec_delete_unmark", "exec_delete_mark", "exec_delete_set", "exec_delete_range"]
    #second_menu_delete_style = ["dotted", "RED", nil]

    second_menu_mark = ["◌ Back","◌ Mark specific","◌ Mark partial"]
    second_menu_method_mark = ["exec_mark_specific", "exec_mark_partial"]
    #second_menu_mark_style = ["bubble", "GREEN", nil]

    second_menu_unmark = ["◌ Back","◌ Unmark specific","◌ Unmark partial"]
    second_menu_method_unmark = ["exec_unmark_specific", "exec_unmark_partial"]
    
    second_menu_option = [second_menu_task_file, second_menu_seek, second_menu_delete, second_menu_mark, second_menu_unmark]
    second_menu_method = [second_menu_method_task_file, second_menu_method_seek, second_menu_method_delete, second_menu_method_mark, second_menu_method_unmark]
    #second_menu_style_1 = [second_menu_seek_style, second_menu_delete_style, second_menu_mark_style]
    
    #End create secondMenu

    #Start create thirdMenu 
    
    #Start menu for the third level of the file

    third_menu_seek_file = ["◈ Back", "◈ Seek specific file", "◈ Seek partial file"]
    third_menu_method_seek_file = ["exec_file_option_function(\"exec_seek_specific(1)\")", "exec_file_option_function(\"exec_seek_partial(1)\")"]

    third_menu_delete_file = ["◈ Back", "◈ Delete specific file", "◈ Delete partial file", "◈ Delete by range file"]
    third_menu_method_delete_file = ["exec_file_option_function(\"exec_delete_specific(1)\")", "exec_file_option_function(\"exec_delete_partial(1)\")", "exec_file_option_function(\"exec_delete_range(1)\")"]

    #End menu for the third level of the file

    #Start agroup in the menu of file

    third_menu_file = [third_menu_seek_file, third_menu_delete_file]
    third_menu_method_file = [third_menu_method_seek_file, third_menu_method_delete_file]

    #End agroup in the menu of file

    third_menu_option = [third_menu_file]
    third_menu_method = [third_menu_method_file]

    #End create thirdMenu

    menu_option = [principal_menu_option, second_menu_option, third_menu_option]
    menu_method = [principal_menu_method, second_menu_method, third_menu_method]
    #menu_style = [principal_menu_style]

    menu_level = 1

    result = exec_menu(menu_option, menu_method, menu_level-1)
    #with menu style -> exec_menu(menu_option, menu_method, menu_level-1, menu_style)

    puts result
    
  end
  
  def exec_create_file

    confirm_out = false

    create_new_file = false
    
    while !confirm_out
      @@console.apply_margin

      puts "#{@@console.get_space}Write the #{@@console.get_color("GREEN")}NAME#{@@console.get_color("DEFAULT")} of the file"
      puts "#{@@console.get_space}Write a #{@@console.get_color("GREEN")}VALID#{@@console.get_color("DEFAULT")} name"
      puts "#{@@console.get_space}No #{@@console.get_color("GREEN")}SPECIAL CHARACTERS OR NUMBERS#{@@console.get_color("DEFAULT")} are allowed"
      puts "\n#{@@console.get_space}Press #{@@console.get_color("CYAN")}enter#{@@console.get_color("DEFAULT")} to create\n\n\n"

      print "#{@@console.get_space}FILE -> "
      print "#{@@console.get_color("CYAN")}"
      file_name = gets
      file_name = file_name.strip
      print "#{@@console.get_color("DEFAULT")}"

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
      print "#{@@console.apply_margin}"

      if file_name.empty? || !Utility.is_valid_file_name(file_name)
        @@console.apply_margin
        @@console.cancel_message("Invalid name\n")

        confirm_out = wait_confirm("creating files")
        next
      end

      #Join the path with the name of the file
      file_path = File.join(@@paths["DirectoryListTask"], "#{file_name}.txt")

      #Make sure that the file not exists
      if File.exist?(file_path)
        @@console.apply_margin
        
        @@console.cancel_message("The file already exists\n")
        @@console.cancel_message("Choose another name\n")
        
        confirm_out = wait_confirm("creating files")
        
        next

      end

      begin

        File.new(file_path, "w").close

        File.open(@@paths["FileListOption"], "a") do |file|
          file.puts("#{file_name}.txt")
        end
        
        if @@task.get_file == @@paths["FileListOption"]

          @@task.set_size(@@task.get_size + 1)

        end
        
      rescue StandardError => e
        @@console.cancel_message("Error creating the file")
      end

      @@console.confirm_message("File \"#{file_name}\" created\n")

      create_new_file = true

      confirm_out = wait_confirm("creating files")

    end #while loop

    return create_new_file

  end 
  
  def exec_file_option_function(function)

    previous_file = @@task.get_file

    @@task.set_file(@@paths["FileListOption"])

    result_method = send(:eval, function)

    return -1 if result_method == -1

    result_method = @@task.set_file(previous_file)

    if !@@task.isEmpty && result_method == -1

      result_method = load_menu_file

    end

    return result_method
    
  end

  def load_menu_file

    max_char_size = 8 #the limit of characters to check if the file is empty
    content_file = "" #to verify the content of the file

    file_task_option = "FILE_OPTION.txt"
    task_menu_option = []
    task_menu_method = []

    if !File.exist?(file_task_option) || File.zero?(file_task_option)
      return -1
    end

    content_file = IO.read(file_task_option, max_char_size)
    content_file = content_file.gsub(/[^[:ascii:]]/, "")

    if(content_file.empty?)
      return -1
    end

    File.open(file_task_option, "r") do |file|

      while (line = file.gets)

        task_menu_option.push(line.strip)

      end

    end

    if task_menu_option.empty?
      return -1
    end

    #ask for "BOM" character
    if task_menu_option[0][0] == "\xEF\xBB\xBF"
      task_menu_option[0].slice!(0)
    end
    
    #Make a default selection if the user dont choose an option
    if task_menu_option.size == 1

      @@task = Task.new(File.join(@@paths["DirectoryListTask"],task_menu_option[0]))
      
      @@console.apply_margin
      @@console.confirm_message("File \"#{task_menu_option[0].split(".")[0]}\" selected")
      @@console.confirm_message("Is the unique file available\n")

      wait_enter

      print @@console.get_utility("CLEAN_SCREEN")

    end
    
    #Select one file by default if the user dont choose one
    @@task = Task.new(File.join(@@paths["DirectoryListTask"],task_menu_option[-1]))

    for i in 0..task_menu_option.size-1

      task_menu_method.push("set_task('#{task_menu_option[i]}')")

      #Make that the user not need to know the extension of the file
      task_menu_option[i] = "◉ #{task_menu_option[i].split(".")[0]}"

    end

    task_menu_option.insert(0, "◉ Exit")

    menu_level = 1

    menu_option = [task_menu_option]
    menu_method = [task_menu_method]

    #if exists more than 1 file to select
    if task_menu_method.size > 1

      exec_menu(menu_option, menu_method, menu_level-1)

    end

    return 0

  end

  def read_char

    STDIN.echo = false
    STDIN.raw!
    input = STDIN.getch

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.cooked!

    return input.downcase
    
  end
  
  def set_task(task_file)

    @@task = Task.new(File.join(@@paths["DirectoryListTask"],task_file))

    @@console.apply_margin

    @@console.confirm_message("File \"#{task_file.split(".")[0]}\" selected\n")

    wait_enter

  end

  def principal_menu_instruction
    
    puts "\n"

    puts "#{@@console.get_space}Navigate with #{@@console.get_utility("UNDERLINE")}#{@@console.get_utility("BOLD")}up, down#{@@console.get_utility("DEFAULT")}"
    puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}and enter#{@@console.get_color("DEFAULT")} keys"
  end

  def exec_menu(menu_option, menu_method, menu_level, menu_style = nil)
        
    option = 1
    enter = false

    loop do

      if menu_style != nil

        @@shape.draw_box_menu(menu_option[menu_level], option, *menu_style[menu_level])

      else

        @@shape.draw_box_menu(menu_option[menu_level], option)

      end

      principal_menu_instruction

      input = read_char
      input = input.strip
      
      print @@console.get_utility("CLEAN_SCREEN")
      
      if input_key(input, option, menu_option[menu_level].size) == -1

        if option == 0
          break
        end

        enter = true

      else

        option = input_key(input, option, menu_option[menu_level].size)

      end

      if enter

        enter = false
        
        if menu_method[menu_level][option-1] == "menu"

          index_next_menu = get_menu_index(menu_method, menu_level, option-1)

          #exec_second_method the return could be
          #result_method with the following values
          #1.An array with 0-> is_third_menu_selected, 1-> third_menu_index, 2-> option_previous
          #2.A value of -1 indicates that occur an error and need to exit

          result_method_second = exec_second_menu(menu_option, menu_method, menu_level+1, index_next_menu, menu_style, 1)
          
          return -1 if result_method_second == -1

          while result_method_second[0]

            result_method = exec_third_menu(menu_option[menu_level+2][index_next_menu][ result_method_second[1] ], menu_method[menu_level+2][index_next_menu][ result_method_second[1] ])
            
            return -1 if result_method == -1

            result_method_second = exec_second_menu(menu_option, menu_method, menu_level+1, index_next_menu, menu_style, result_method_second[2])
            
            return -1 if result_method_second == -1

          end
          
          option = result_method_second[2]

        else
        
          send(:eval, menu_method[menu_level][option-1])
        
        end

      end
      
      print "#{@@console.get_utility("CLEAN_SCREEN")}"

    end #loop

  end #function

  def get_menu_index(menu_method, menu_level, option)

    count = -1
  
    for i in 0..option
  
      if menu_method[menu_level][i] == "menu"
  
        count+=1
  
      end
  
    end
  
    return count
  
  end
  
  def exec_third_menu(third_menu_option, third_menu_method, third_menu_style = nil)

    option = 1

    enter = false

    loop do

      if third_menu_style != nil
        
        @@shape.draw_box_menu(third_menu_option, option, *third_menu_style)

      else

        @@shape.draw_box_menu(third_menu_option, option)

      end

      input = read_char
      input = input.strip

      print @@console.get_utility("CLEAN_SCREEN")

      if input_key(input, option, third_menu_option.size) == -1

        if option == 0
          break
        end

        enter = true

      else

        option = input_key(input, option, third_menu_option.size)

      end
      
      if enter

        enter = false
        
        result_method = send(:eval, third_menu_method[option-1])

      end

      return -1 if result_method == -1

      print "#{@@console.get_utility("CLEAN_SCREEN")}"

    end #loop
    
  end

  def exec_second_menu(second_menu_option, second_menu_method, second_menu_level, index_second_menu, second_menu_style = nil, option)

    selected_menu_option = option

    enter = false

    loop do

      if second_menu_style != nil && second_menu_style[second_menu_level] != nil
        
        @@shape.draw_box_menu(second_menu_option[second_menu_level][index_second_menu], option, *second_menu_style[second_menu_level][index_second_menu])

      else

        @@shape.draw_box_menu(second_menu_option[second_menu_level][index_second_menu], option)

      end

      input = read_char
      input = input.strip
      
      print @@console.get_utility("CLEAN_SCREEN")
      
      if input_key(input, option, second_menu_option[second_menu_level][index_second_menu].size) == -1

        if option == 0
          break
        end

        enter = true

      else

        option = input_key(input, option, second_menu_option[second_menu_level][index_second_menu].size)

        selected_menu_option = (option <= 0 ? 1 : option)

      end

      if enter

        enter = false
        
        if second_menu_method[second_menu_level][index_second_menu][option-1] == "menu"

          index_next_menu = get_second_menu_index(second_menu_method, second_menu_level, index_second_menu, option-1)

          #1-> if the user select a menu, 2-> what menu is selected
          return [true, index_next_menu, selected_menu_option]
          
        else

          result_method = send(:eval, second_menu_method[second_menu_level][index_second_menu][option-1])
          
        end

      end

      return -1 if result_method == -1

      print "#{@@console.get_utility("CLEAN_SCREEN")}"

    end
    
    return [false, 0, 1]

  end

  def get_second_menu_index(second_menu_method, second_menu_level, index_second_menu, option)

    count = -1
  
    for i in 0..index_second_menu-1
  
      second_menu_method[second_menu_level][i].each do |element|
  
        if element == "menu"
  
          count+=1
  
        end
  
      end
  
    end
  
    for i in 0..option
  
      if second_menu_method[second_menu_level][index_second_menu][i] == "menu"
  
        count+=1
  
      end
  
    end
  
    return count
  
  end

  def exec_mark_specific
    
    save_line = get_task_by_category_line(0)

    confirm_out = false

    page = 0

    while !confirm_out

      page = pagination_line(save_line, page)

      break if save_line.empty?

      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_color("GREEN")}-->#{@@console.get_color("DEFAULT")} Mark a task as done for their #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")} \n\n\n"

      print "#{@@console.get_space}MARK -> "
      print "#{@@console.get_color("CYAN")}"
      input = gets
      input = input.strip
      print "#{@@console.get_color("DEFAULT")}"
    
      print "#{@@console.get_utility("CLEAN_SCREEN")}"

      @@console.apply_margin    

      begin

        index = Integer(input)
        
      rescue ArgumentError
      
        print "#{@@console.get_utility("CLEAN_SCREEN")}"

        @@console.apply_margin

        @@console.cancel_message("You must insert a NUMBER")
    
        print "\n"

        confirm_out = wait_confirm("marking")

        next

      end

      if index < 1 || index > save_line.size

        @@console.cancel_message("That task is no available to mark as done")

        print "\n"

        confirm_out = wait_confirm("marking")
          
        next

      end

      pagination_line([index], 0)
            
      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to mark this task?#{@@console.get_utility("DEFAULT")}"
      print "\n"

      confirm_out = wait_confirm("to mark the task")
      
      if confirm_out

        @@console.apply_margin

        confirm_out = wait_confirm("marking")

        next

      end

      @@console.apply_margin

      @@task.mark_line([save_line[index - 1]])
        
      print "\n"

      save_line.delete_at(index-1)

      confirm_out = wait_confirm("marking")
          
    end
    
  end
 
  def exec_unmark_specific

    save_line = get_task_by_category_line(2)
    confirm_out = false
    page = 0

    while !confirm_out
      page = pagination_line(save_line, page)

      break if save_line.empty?

      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_color("GREEN")}-->#{@@console.get_color("DEFAULT")} Unmark a task for their #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")}\n\n\n"

      print "#{@@console.get_space}UNMARK -> "
      print "#{@@console.get_color("CYAN")}"
      input = gets
      input = input.strip
      print "#{@@console.get_color("DEFAULT")}"

      print "#{@@console.get_utility("CLEAN_SCREEN")}"

      @@console.apply_margin

      begin
        index = Integer(input)
      rescue ArgumentError
        print "#{@@console.get_utility("CLEAN_SCREEN")}"
        @@console.apply_margin
        @@console.cancel_message("You must insert a NUMBER")
        print "\n"
        confirm_out = wait_confirm("unmarking")
        next
      end

      if index < 1 || index > save_line.size
        @@console.cancel_message("That task is not available to unmark")
        print "\n"
        confirm_out = wait_confirm("unmarking")
        next
      end

      pagination_line([index], 0)
      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to unmark this task?#{@@console.get_utility("DEFAULT")}"
      print "\n"

      confirm_out = wait_confirm("to unmark the task")

      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("unmarking")
        next
      end

      @@console.apply_margin

      @@task.unmark_line([save_line[index - 1]])

      print "\n"

      save_line.delete_at(index - 1)

      confirm_out = wait_confirm("unmarking")

    end

  end

  def exec_mark_partial
    save_line = get_task_by_category_line(0)
    partial_line = []
    confirm_out = false
    
    while !confirm_out
      @@console.apply_margin

      puts "#{@@console.get_space}Mark a task as done for a #{@@console.get_color("GREEN")}CONTENT#{@@console.get_color("DEFAULT")} of the task\n\n\n"
      puts "#{@@console.get_space}You can mark all the tasks #{@@console.get_color("CYAN")}all#{@@console.get_color("DEFAULT")} the task only pressing #{@@console.get_color("CYAN")}enter#{@@console.get_color("DEFAULT")}"
      puts ""
      print "#{@@console.get_space}MARK -> "
      print "#{@@console.get_color("CYAN")}"
      content = gets
      print "#{@@console.get_color("DEFAULT")}"
      content = content.strip

      print "\n"
      print "#{@@console.get_space}LOADING PAGES"

      partial_line = @@task.get_line_partial(save_line, content)
      pagination_line(partial_line, 0)

      if partial_line.empty?
        @@console.apply_margin
        confirm_out = wait_confirm("marking")
        next
      end

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
      @@console.apply_margin

      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to mark this task?#{@@console.get_utility("DEFAULT")}"
      print "\n"

      confirm_out = wait_confirm("to mark the tasks")

      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("marking")
        next
      end

      @@console.apply_margin
      @@task.mark_line(partial_line)

      for i in 0..partial_line.size - 1
        save_line.delete_at(@@task.binary_search(save_line, partial_line[i]))
      end

      print "\n"
      confirm_out = wait_confirm("marking")
    end
  end

 
  def exec_unmark_partial
    save_line = get_task_by_category_line(2)
    partial_line = []
    confirm_out = false

    while !confirm_out
      @@console.apply_margin

      puts "#{@@console.get_space}Unmark a task for the #{@@console.get_color("GREEN")}CONTENT#{@@console.get_color("DEFAULT")} of the task\n\n\n"
      puts "#{@@console.get_space}You can unmark all the tasks #{@@console.get_color("CYAN")}all#{@@console.get_color("DEFAULT")} the task only pressing #{@@console.get_color("CYAN")}enter#{@@console.get_color("DEFAULT")}"
      puts ""
      print "#{@@console.get_space}UNMARK -> "
      print "#{@@console.get_color("CYAN")}"
      content = gets
      print "#{@@console.get_color("DEFAULT")}"
      content = content.strip

      print "\n"
      print "#{@@console.get_space}LOADING PAGES"

      partial_line = @@task.get_line_partial(save_line, content)
      pagination_line(partial_line, 0)

      if partial_line.empty?
        @@console.apply_margin
        confirm_out = wait_confirm("unmarking")
        next
      end

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
      @@console.apply_margin

      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to unmark this tasks?#{@@console.get_utility("DEFAULT")}"
      print "\n"
      confirm_out = wait_confirm("to unmark the tasks")

      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("unmarking")
        next
      end

      @@console.apply_margin
      @@task.unmark_line(partial_line)

      for i in 0..partial_line.size - 1
        save_line.delete_at(@@task.binary_search(save_line, partial_line[i]))
      end

      print "\n"
      confirm_out = wait_confirm("unmarking")
    end

  end

  def exec_update
    
    save_byte = get_task_by_category_byte(1)
    confirm_out = false
    page = 0

    while !confirm_out

      page = pagination_byte(save_byte, page)
      break if save_byte.empty?

      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_color("GREEN")}-->#{@@console.get_color("DEFAULT")} Update a task for their #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")}\n\n\n"

      print "#{@@console.get_space}UPDATE -> "
      print "#{@@console.get_color("CYAN")}"
      input = gets
      input = input.strip
      print "#{@@console.get_color("DEFAULT")}"

      print "#{@@console.get_utility("CLEAN_SCREEN")}"

      begin
        index = Integer(input)
      rescue ArgumentError
        print "#{@@console.get_utility("CLEAN_SCREEN")}"
        @@console.apply_margin
        @@console.cancel_message("You must insert a NUMBER")
        print "\n"
        confirm_out = wait_confirm("updating")
        next
      end

      if index < 1 || index > save_byte.size
        @@console.apply_margin
        @@console.cancel_message("That task is not available to update")
        print "\n"
        confirm_out = wait_confirm("updating")
        next
      end

      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_color("GREEN")}Write#{@@console.get_color("DEFAULT")} a new task to update"
      puts ""
      print "#{@@console.get_space}UPDATE -> "
      print @@console.get_color("CYAN")
      content = gets
      print @@console.get_color("DEFAULT")
      content = content.strip
      print "#{@@console.get_utility("CLEAN_SCREEN")}"

      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to update this task?#{@@console.get_utility("DEFAULT")}"
      print "\n"
      confirm_out = wait_confirm("to update the task")

      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("updating")
        next
      end

      @@console.apply_margin
      @@task.update_line(index, content)

      byte_value = (content.bytesize + 2)

      difference_value = save_byte[index - 1] - byte_value

      puts "index #{index}"
      puts "before save_byte #{save_byte}"

      if index < save_byte.size
        temp_value = save_byte[index]
        save_byte[index] = (((save_byte[index] - save_byte[index - 1]) - byte_value) - save_byte[index]).abs
      end

      for i in (index + 1)..save_byte.size - 1
        next_value = save_byte[i]
        save_byte[i] -= temp_value - save_byte[i - 1]
        temp_value = next_value
      end

      puts "after #{save_byte}"
      puts "espected #{get_task_by_category_byte(1)}"

      print "\n"
      confirm_out = wait_confirm("updating")
    end
  end
  
  #delete mode
  #0 -> Normal task
  #1 -> File
  def exec_delete_specific(delete_mode = 0)
    
    confirm_out = false

    while !confirm_out

      @@console.apply_margin

      puts "#{@@console.get_space}#{@@console.get_color("GREEN")}-->#{@@console.get_color("DEFAULT")} Delete a task for their #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")}\n\n\n"
      #show all the task available
      puts "#{@@console.get_space}Task available to delete -> #{@@task.get_size}"
      puts ""
      print "#{@@console.get_space}DELETE -> "
      print "#{@@console.get_color("CYAN")}"
      input = gets
      input = input.strip
      print "#{@@console.get_color("DEFAULT")}"
    
      print "#{@@console.get_utility("CLEAN_SCREEN")}"

      begin

        index = Integer(input)
        
      rescue ArgumentError

        @@console.apply_margin

        @@console.cancel_message("You must insert a NUMBER")

        print "\n"

        confirm_out = wait_confirm("deleting")

        next

      end

      if index < 0 || index > @@task.get_size

        @@console.apply_margin

        @@console.cancel_message("That task is no available to delete")

        print "\n"

        confirm_out = wait_confirm("deleting")

        next

      end

      pagination_line([index], 0, delete_mode)

      @@console.apply_margin
            
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to delete this task?#{@@console.get_utility("DEFAULT")}"
      
      print "\n"
      
      confirm_out = wait_confirm("to delete the task")
      
      if confirm_out

        @@console.apply_margin

        confirm_out = wait_confirm("deleting")

        next

      end

      @@console.apply_margin 
      
      result_delete = @@task.delete_line([index], delete_mode)

      #if delete the last file give the oportunity to the user
      #to create a new file
      if delete_mode == 1 && result_delete < 0

        #if not create a file stop the program
        #until exists a new file

        if !exec_create_file

          @@console.cancel_message("No file created\n")

          return -1

        end

      end
      
      print "\n"

      confirm_out = wait_confirm("deleting")

    end
    
  end
  
  def exec_status_task
    
    page = 0
    category_task = 1
    confirm_out = false

    while !confirm_out

      #i used "_" to refer a variable that in this context not need
      _, page, category_task = pagination_line_filter(page, category_task)

      @@console.apply_margin 

      confirm_out = wait_confirm("searching")
      
    end

  end
  
  def exec_delete_partial(delete_mode = 0)
    save_line = get_task_by_category_line(1)
    partial_line = []
    confirm_out = false

    while !confirm_out
      @@console.apply_margin

      puts "#{@@console.get_space}Make a seek partial for a #{@@console.get_color("GREEN")}CONTENT#{@@console.get_color("DEFAULT")} of the task\n\n\n"
      puts "#{@@console.get_space}You can seek #{@@console.get_color("CYAN")}all#{@@console.get_color("DEFAULT")} the tasks only by pressing #{@@console.get_color("CYAN")}enter#{@@console.get_color("DEFAULT")}"
      puts ""
      print "#{@@console.get_space}SEARCH -> "
      print "#{@@console.get_color("CYAN")}"
      content = gets.strip
      print "#{@@console.get_color("DEFAULT")}"

      print "\n"
      print "#{@@console.get_space}LOADING PAGES"

      partial_line = @@task.get_line_partial(save_line, content)

      pagination_line(partial_line, 0)

      if partial_line.empty?
        @@console.apply_margin
        confirm_out = wait_confirm("deleting")
        next
      end

      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to delete these tasks?#{@@console.get_utility("DEFAULT")}"
      print "\n"

      confirm_out = wait_confirm("to delete the tasks")

      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("deleting")
        next
      end

      @@console.apply_margin
      result_delete = @@task.delete_line(partial_line, delete_mode)

      #if delete the last file give the oportunity to the user
      #to create a new file
      if delete_mode == 1 && result_delete < 0

        #if not create a file stop the program
        #until exists a new file
        if !exec_create_file

          @@console.cancel_message("No file created\n")

          return -1

        end

      end
      
      ((partial_line.size)..save_line.size-1).each do |i|
        save_line[i] -= partial_line.size
      end

      (0..partial_line.size-1).each do |i|
        save_line.delete_at(0)
      end

      print "\n"
      confirm_out = wait_confirm("deleting")
    end
  end

  def exec_delete_unmark
    
    #store the index of each line that match with the search content
    save_line = get_task_by_category_line(0)
    
    confirm_out = false

    page = 0

    #Keep track the page
    while !confirm_out

      page = pagination_line(save_line, page)
      
      if save_line.empty? 

        @@console.apply_margin

        confirm_out = wait_confirm("to delete the tasks")

        next

      end  
      
      @@console.apply_margin

      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to delete these task?#{@@console.get_utility("DEFAULT")}"

      print "\n"
      
      confirm_out = wait_confirm("to delete the tasks")

      if confirm_out
        
        @@console.apply_margin

        confirm_out = wait_confirm("deleting")

        next
        
      end

      @@console.apply_margin

      @@task.delete_line(save_line)
        
      #"delete the task"
      save_line = []

      print "\n"

      confirm_out = wait_confirm("deleting")
      
    end
    
  end

  def exec_delete_mark

    save_line = get_task_by_category_line(2)
    confirm_out = false
    page = 0

    while !confirm_out
      
      page = pagination_line(save_line, page)
  
      if save_line.empty?
        @@console.apply_margin
        confirm_out = wait_confirm("deleting")
        next
      end  
  
      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to delete these tasks?#{@@console.get_utility("DEFAULT")}"
      print "\n"
  
      confirm_out = wait_confirm("to delete the tasks")
  
      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("deleting")
        next
      end
  
      @@console.apply_margin
      @@task.delete_line(save_line)
  
      #Delete the tasks
      save_line = []
  
      print "\n"
      confirm_out = wait_confirm("deleting")
    end

  end
  

  #Categories
  #0 -> pending
  #1 -> All
  #2 -> finished
  def get_task_by_category_line(category_task)

    case category_task
    when 0
      save_line = @@task.get_pending_line
    
    when 1
      save_line = @@task.get_finished_pending_line
    
    when 2
      save_line = @@task.get_finished_line

    else
      save_line = [0]
    end

    return save_line

  end
  
  #Categories
  #0 -> pending
  #1 -> All
  #2 -> finished
  def get_task_by_category_byte(category_task)

    case category_task
      
    when 0
      save_byte = @@task.get_pending_byte
    
    when 1
      save_byte = @@task.get_finished_pending_byte
    
    when 2
      save_byte = @@task.get_finished_byte

    else
      save_byte = [0]
    end

    return save_byte

  end
  
  #display_mode
  #0 -> normal task
  #1 -> file
  def pagination_line_filter(page, category_task, display_mode = 0)

    prev_category = category_task

    filter_option = ["P (pending)", "A (all)", "F (finished)"]
    
    start_index = 0 

    end_index = 0

    difference_start = 0

    difference_end = 0

    #store the index of each line that match with the search content
    save_line = get_task_by_category_line(category_task)
    
    limit_page = (save_line.size / (@@console.size_show_line + 0.0)).ceil

    invalid_page = false

    @@console.apply_margin
    
    print "#{@@console.get_space}LOADING PAGES"
    
    if page >= limit_page
      page = limit_page-1
    end
    
    loop do
      
      start_index = page * @@console.size_show_line

      end_index = start_index + @@console.size_show_line

      difference_start = save_line.size - start_index

      if(difference_start < 0)
        start_index += difference_start
      end   

      difference_end = save_line.size - end_index   
      
      if(difference_end < 0)
        end_index += difference_end
      end

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
        
      @@console.apply_margin

      @@task.pagination_line(save_line[start_index..end_index-1], page, display_mode)

      print "\n" 
      puts "#{@@console.get_space}To #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}navigate#{@@console.get_color("DEFAULT")} throught the tasks"
      puts "#{@@console.get_space}left key #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}<---#{@@console.get_color("DEFAULT")}  or  #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}--->#{@@console.get_color("DEFAULT")} right key"
      print "#{@@console.get_space}Press key"

      for i in 0..filter_option.size-1

        if i == category_task

          print "#{@@console.get_utility("BOLD")}#{@@console.get_color("GREEN")} #{filter_option[i]}#{@@console.get_utility("DEFAULT")}"

        else

          print " #{filter_option[i]}"

        end

      end
      
      puts "\n#{@@console.get_space}Exit -> #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}ANY#{@@console.get_color("DEFAULT")} key"
        
      print "\n#{@@console.get_space}Page #{page+1} / #{limit_page}"

      input = read_char
      input = input.strip
      
      invalid_key = (get_input_category(input) == -1 && pagination_key(input, page, limit_page) == -1)
        
      break if (limit_page <= 0 || invalid_key) && get_input_category(input) == -1
      
      page = pagination_key(input, page, limit_page) if pagination_key(input, page, limit_page) != -1

      if(get_input_category(input) != -1 && prev_category != get_input_category(input))
        
        category_task = get_input_category(input)

        print "#{@@console.get_utility("CLEAN_SCREEN")}"

        @@console.apply_margin
    
        print "#{@@console.get_space}LOADING PAGES"

        save_line = get_task_by_category_line(category_task)
        
        prev_category = category_task

        limit_page = (save_line.size / (@@console.size_show_line + 0.0)).ceil

        page = 0
    
        if limit_page <= 0
          page = -1
        end

      end
      
    end    

    print "#{@@console.get_utility("CLEAN_SCREEN")}"

    return [save_line, page, category_task]
    
  end

  #the display_mode is used to know if the pagination is for a normal task or 
  #for a file or another specific type
  #0 -> normal task
  #1 -> file
  def pagination_line(save_line, page, display_mode = 0)

    limit_page = (save_line.size / (@@console.size_show_line + 0.0)).ceil
    
    start_index = 0

    end_index = 0

    difference_start = 0

    difference_end = 0

    #store the index of each line that match with the search content
    @@console.apply_margin
    
    print "#{@@console.get_space}LOADING PAGES"      

    if page >= limit_page

      page = limit_page-1

    end
        
    loop do
      
      start_index = page * @@console.size_show_line

      end_index = start_index + @@console.size_show_line

      difference_start = save_line.size - start_index

      if(difference_start < 0)
        start_index += difference_start
      end   

      difference_end = save_line.size - end_index   
      
      if(difference_end < 0)
        end_index += difference_end
      end

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
        
      @@console.apply_margin

      @@task.pagination_line(save_line[start_index..end_index-1], page, display_mode)

      print "\n" 
    
      puts "#{@@console.get_space}To #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}navigate#{@@console.get_color("DEFAULT")} throught the tasks"
      puts "#{@@console.get_space}left key #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}<---#{@@console.get_color("DEFAULT")}  or  #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}--->#{@@console.get_color("DEFAULT")} right key"
      puts "\n#{@@console.get_space}Exit -> #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}ANY#{@@console.get_color("DEFAULT")} key"
        
      print "\n#{@@console.get_space}Page #{page+1} / #{limit_page}"

      input = read_char
      input = input.strip
      
      break if (limit_page <= 0 || pagination_key(input, page, limit_page) == -1)

      page = pagination_key(input, page, limit_page)

    end    

    print "#{@@console.get_utility("CLEAN_SCREEN")}"

    return page

  end
  
  def pagination_byte_filter(page, category_task)

    prev_category = category_task

    filter_option = ["P (pending)", "A (all)", "F (finished)"]
    
    start_index = 0 

    end_index = 0

    difference_start = 0

    difference_end = 0

    #store the index of each line that match with the search content
    save_byte = get_task_by_category_line(category_task)
    
    limit_page = (save_byte.size / (@@console.size_show_line + 0.0)).ceil

    invalid_page = false

    @@console.apply_margin
    
    print "#{@@console.get_space}LOADING PAGES"
    
    if page >= limit_page
      page = limit_page-1
    end
    
    loop do
      
      start_index = page * @@console.size_show_line

      end_index = start_index + @@console.size_show_line

      difference_start = save_byte.size - start_index

      if(difference_start < 0)
        start_index += difference_start
      end   

      difference_end = save_byte.size - end_index   
      
      if(difference_end < 0)
        end_index += difference_end
      end

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
        
      @@console.apply_margin

      @@task.pagination_line(save_byte[start_index..end_index-1], page)

      print "\n" 
      puts "#{@@console.get_space}To #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}navigate#{@@console.get_color("DEFAULT")} throught the tasks"
      puts "#{@@console.get_space}left key #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}<---#{@@console.get_color("DEFAULT")}  or  #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}--->#{@@console.get_color("DEFAULT")} right key"
      print "#{@@console.get_space}Press key"

      for i in 0..filter_option.size-1

        if i == category_task

          print "#{@@console.get_utility("BOLD")}#{@@console.get_color("GREEN")} #{filter_option[i]}#{@@console.get_utility("DEFAULT")}"

        else

          print " #{filter_option[i]}"

        end

      end
      
      puts "\n#{@@console.get_space}Exit -> #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}ANY#{@@console.get_color("DEFAULT")} key"
        
      print "\n#{@@console.get_space}Page #{page+1} / #{limit_page}"

      input = read_char
      input = input.strip
      
      invalid_key = (get_input_category(input) == -1 && pagination_key(input, page, limit_page) == -1)
        
      break if (limit_page <= 0 || invalid_key) && get_input_category(input) == -1
      
      page = pagination_key(input, page, limit_page) if pagination_key(input, page, limit_page) != -1

      if(get_input_category(input) != -1 && prev_category != get_input_category(input))
        
        category_task = get_input_category(input)

        print "#{@@console.get_utility("CLEAN_SCREEN")}"

        @@console.apply_margin
    
        print "#{@@console.get_space}LOADING PAGES"

        save_byte = get_task_by_category_byte(category_task)
        
        prev_category = category_task

        limit_page = (save_byte.size / (@@console.size_show_line + 0.0)).ceil

        page = 0
    
        if limit_page <= 0
          page = -1
        end

      end
      
    end    

    print "#{@@console.get_utility("CLEAN_SCREEN")}"

    return [save_line, page, category_task]
    
  end

  def pagination_byte(save_byte, page, display_mode = 0)

    limit_page = (save_byte.size / (@@console.size_show_line + 0.0)).ceil
    
    start_index = 0 

    end_index = 0

    difference_start = 0

    difference_end = 0

    #store the index of each line that match with the search content
    
    @@console.apply_margin
    
    print "#{@@console.get_space}LOADING PAGES"
    
    if page >= limit_page

      page = limit_page-1

    end
        
    loop do
      
      start_index = page * @@console.size_show_line

      end_index = start_index + @@console.size_show_line

      difference_start = save_byte.size - start_index

      if(difference_start < 0)
        start_index += difference_start
      end   

      difference_end = save_byte.size - end_index   
      
      if(difference_end < 0)
        end_index += difference_end
      end

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
        
      @@console.apply_margin

      @@task.pagination_byte(save_byte[start_index..end_index-1], page, display_mode)

      print "\n" 
    
      puts "#{@@console.get_space}To #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}navigate#{@@console.get_color("DEFAULT")} throught the tasks"
      puts "#{@@console.get_space}left key #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}<---#{@@console.get_color("DEFAULT")}  or  #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}--->#{@@console.get_color("DEFAULT")} right key"
      puts "\n#{@@console.get_space}Exit -> #{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}ANY#{@@console.get_color("DEFAULT")} key"
        
      print "\n#{@@console.get_space}Page #{page+1} / #{limit_page}"

      input = read_char
      input = input.strip
      
      break if (limit_page <= 0 || pagination_key(input, page, limit_page) == -1)

      page = pagination_key(input, page, limit_page)

    end    

    print "#{@@console.get_utility("CLEAN_SCREEN")}"
      
    return page

  end
  
  def exec_delete_set

    confirm_out = false

    page = 0

    category_task = 1

    while !confirm_out

      #make a filter for a pending, realize and both
      save_line, page, category_task = pagination_line_filter(page, category_task)

      if(save_line.empty?)

        @@console.apply_margin

        @@console.cancel_message("Task category selected is empty (finished, pending, all)")

        print "\n"

        confirm_out = wait_confirm("deleting")

        next

      end

      input = ""

      @@console.apply_margin

      puts "#{@@console.get_space}Delete a set by writing their #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")}"
      puts "#{@@console.get_space}And separate each tasks by #{@@console.get_color("GREEN")}SPACE#{@@console.get_color("DEFAULT")}\n\n\n"
      print "#{@@console.get_space}Enter the set of tasks -> "

      print "#{@@console.get_color("CYAN")}"

      input = gets
      
      print "#{@@console.get_color("DEFAULT")}"

      print "#{@@console.get_utility("CLEAN_SCREEN")}"

      set_task = input.split(" ")

      if(set_task.empty?)

        @@console.apply_margin

        @@console.cancel_message("The set of tasks is empty")
  
        print "\n"

        confirm_out = wait_confirm("deleting")

        next

      end

      begin

        for i in 0..set_task.size-1

          num = Integer(set_task[i])

          if num <= 0 or num > save_line.size

            @@console.apply_margin

            @@console.cancel_message("Not valid number of a task")

            print "\n"

            confirm_out = wait_confirm("deleting")

            next

          end

          set_task[i] = num

        end
        
      rescue ArgumentError

        @@console.apply_margin

        @@console.cancel_message("Conversion invalid to number in the set")

        print "\n"

        confirm_out = wait_confirm("deleting")
        
        next

      end

      @@console.apply_margin

      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to delete these task?#{@@console.get_utility("DEFAULT")}"

      print "\n"

      confirm_out = wait_confirm("to delete the tasks")

      if confirm_out

        @@console.apply_margin

        confirm_out = wait_confirm("deleting")

        next

      end

      set_task = set_task.sort

      set_task = @@task.delete_duplicate_sort(set_task) 

      @@task.delete_set(save_line, set_task)

      print "\n"

      confirm_out = wait_confirm("deleting")
      
    end
    
  end

  def exec_delete_range(delete_mode = 0)
    
    start_range = 0
    end_range = 0
    swap = 0
    confirm_out = false
    page = 0
    category_task = 1

    while !confirm_out
      save_line, page, category_task = pagination_line_filter(page, category_task, delete_mode)
  
      if save_line.empty?
        @@console.apply_margin
        @@console.cancel_message("Task category selected is empty (finished, pending, all)")
        print "\n"
        confirm_out = wait_confirm("deleting")
        next
      end
  
      input = ""
  
      # Start range
      @@console.apply_margin
      puts "#{@@console.get_space}Delete a set by writing the start #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")}"
      puts "#{@@console.get_space}And the end #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")} of the range\n\n\n"
      print "#{@@console.get_space}start -> "
      print "#{@@console.get_color("CYAN")}"
  
      input = gets.strip
  
      print "#{@@console.get_color("DEFAULT")}"
      print "#{@@console.get_utility("CLEAN_SCREEN")}"
  
      begin
        start_range = Integer(input)
      rescue ArgumentError
        @@console.apply_margin
        @@console.cancel_message("Conversion invalid to number")
        print "\n"
        confirm_out = wait_confirm("deleting")
        next
      end

      if start_range <= 0 || start_range > save_line.size
        @@console.apply_margin
        @@console.cancel_message("The number is out of the range bounds")
        print "\n"
        confirm_out = wait_confirm("deleting")
        next
      end
  
      input = ""
  
      # End range
      @@console.apply_margin
      puts "#{@@console.get_space}Delete a set by writing the start #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")}"
      puts "#{@@console.get_space}And the end #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")} of the range\n\n\n"
      print "#{@@console.get_space}start -> #{start_range}\n"
      print "#{@@console.get_space}end -> "
      print "#{@@console.get_color("CYAN")}"
  
      input = gets.strip
  
      print "#{@@console.get_color("DEFAULT")}"
      print "#{@@console.get_utility("CLEAN_SCREEN")}"
  
      begin
        end_range = Integer(input)
      rescue ArgumentError
        @@console.apply_margin
        @@console.cancel_message("Conversion invalid to number")
        print "\n"
        confirm_out = wait_confirm("deleting")
        next
      end
  
      if end_range <= 0 || end_range > save_line.size
        @@console.apply_margin
        @@console.cancel_message("The number is out of the range bounds")
        print "\n"
        confirm_out = wait_confirm("deleting")
        next
      end
  
      @@console.apply_margin
      puts "#{@@console.get_space}#{@@console.get_utility("BOLD")}#{@@console.get_utility("UNDERLINE")}¿Are you sure that you want to delete these tasks?#{@@console.get_utility("DEFAULT")}"
      print "\n"
  
      confirm_out = wait_confirm("to delete the tasks")
  
      if confirm_out
        @@console.apply_margin
        confirm_out = wait_confirm("deleting")
        next
      end
  
      # Swap the values
      if end_range < start_range
        swap = end_range
        end_range = start_range
        start_range = swap
      end
  
      @@console.apply_margin
      result_delete = @@task.delete_range(save_line[start_range - 1..end_range - 1], delete_mode)
      
      #if delete the last file give the oportunity to the user
      #to create a new file
      if delete_mode == 1 && result_delete < 0

        #if not create a file stop the program
        #until exists a new file
        if !exec_create_file

          @@console.cancel_message("No file created\n")

          return -1

        end

      end
      
      print "\n"
      confirm_out = wait_confirm("deleting")
    end #while

  end #method
  
  def exec_seek_specific(display_mode = 0)
    
    confirm_out = false
  
    while !confirm_out
      @@console.apply_margin
  
      puts "#{@@console.get_space}Make a seek for the #{@@console.get_color("GREEN")}NUMBER#{@@console.get_color("DEFAULT")} of the task\n\n\n"
      print "#{@@console.get_space}Total of tasks#{@@console.get_color("GREEN")} --> #{@@console.get_color("DEFAULT")}#{@@task.get_size}\n"
      puts ""
      print "#{@@console.get_space}SEARCH -> "
      print "#{@@console.get_color("CYAN")}"
      input = gets
      input = input.strip
      print "#{@@console.get_color("DEFAULT")}"
  
      print "#{@@console.get_utility("CLEAN_SCREEN")}"
  
      begin
        index = Integer(input)
      rescue ArgumentError
        @@console.apply_margin
        @@console.cancel_message("You must insert a NUMBER")
        print "\n"
        confirm_out = wait_confirm("seeking")
        next
      end
  
      if !@@task.exists(index)
        @@console.apply_margin
        @@console.cancel_message("Task not available")
        print "\n"
        confirm_out = wait_confirm("seeking")
        next
      end
  
      pagination_line([index], 0, display_mode)
      @@console.apply_margin
      confirm_out = wait_confirm("seeking")
    end

  end
  
  def wait_confirm(message)

    puts "#{@@console.get_space}Continue #{message} --> #{@@console.get_color("CYAN")}Enter#{@@console.get_color("DEFAULT")}"
    puts "#{@@console.get_space}Back --> #{@@console.get_color("CYAN")}Any other#{@@console.get_color("DEFAULT")}"

    input = read_char
    input = input.strip
    option = input_key(input, 0, -1)
    print "#{@@console.get_utility("CLEAN_SCREEN")}"

    return (option != -1)

  end


  def exec_seek_partial(display_mode = 0)

    save_byte = get_task_by_category_byte(1)
    partial_byte = []
    confirm_out = false

    while !confirm_out
      @@console.apply_margin

      puts "#{@@console.get_space}Make a seek for the #{@@console.get_color("GREEN")}CONTENT#{@@console.get_color("DEFAULT")} of the task"
      puts "\n#{@@console.get_space}Press #{@@console.get_color("CYAN")}enter#{@@console.get_color("DEFAULT")} to search all the tasks\n\n\n"

      print "#{@@console.get_space}SEARCH -> "
      print "#{@@console.get_color("CYAN")}"
      content = gets
      content = content.strip
      print "#{@@console.get_color("DEFAULT")}"

      partial_byte = @@task.get_byte_partial(save_byte, content)
      pagination_byte(partial_byte, 0, display_mode)

      @@console.apply_margin
      confirm_out = wait_confirm("seeking")
    end
  end
  
  def exec_add
    confirm_out = false

    while !confirm_out
      @@console.apply_margin

      puts "#{@@console.get_space}#{@@console.get_color("GREEN")}Write#{@@console.get_color("DEFAULT")} a new task to save it"
      puts ""

      print "#{@@console.get_space}Add -> "
      print @@console.get_color("CYAN")

      content = gets
      print @@console.get_color("DEFAULT")
      content = content.strip

      print "#{@@console.get_utility("CLEAN_SCREEN")}"
      @@console.apply_margin

      @@task.add(content)
      print "\n"

      confirm_out = wait_confirm("adding")
    end
  end

  def wait_enter

    puts "#{@@console.get_space}Press enter to continue"
    option = 0

    while option != -1

      input = read_char
      input = input.strip
      option = input_key(input, option, -1)

    end

  end

  def pagination_key(input, page, limit_page)

    case input.inspect
    when @@console.get_input("ARROW_LEFT_WINDOWS")
      if page >= 0
        page -= 1
      end

      if page < 0
        page = limit_page - 1
      end

      return page

    when @@console.get_input("ARROW_RIGHT_WINDOWS")
      if page < limit_page
        page += 1
      end

      if page >= limit_page
        page = 0
      end

      return page

    end

    case input
    when @@console.get_input("ARROW_LEFT_LINUX")
      if page >= 0
        page -= 1
      end

      if page < 0
        page = limit_page - 1
      end

      return page

    when @@console.get_input("ARROW_RIGHT_LINUX")
      if page < limit_page
        page += 1
      end

      if page >= limit_page
        page = 0
      end

      return page

    end

    return -1
  end
  
  def input_key(input, option, option_size)
    
    #Windows
    case input.inspect
    when @@console.get_input("ARROW_UP_WINDOWS") 
      if option >= 0
        option -= 1       
      end

      if option < 0
        option = option_size - 1
      end

      return option

    when @@console.get_input("ARROW_DOWN_WINDOWS")
      if option <= (option_size - 1)
        option += 1
      end

      if option > (option_size - 1)
        option = 0
      end

      return option

    when @@console.get_input("ENTER_WINDOWS")

      option = -1

      return option
    end

    #Linux
    case input
    when @@console.get_input("ARROW_UP_LINUX") 
      if option >= 0
        option -= 1       
      end

      if option < 0
        option = option_size - 1
      end

      return option

    when @@console.get_input("ARROW_DOWN_LINUX")
      if option <= (option_size - 1)
        option += 1
      end

      if option > (option_size - 1)
        option = 0
      end

      return option

    when @@console.get_input("ENTER_LINUX")

      option = -1

      return option
    end

    return option
  end

 def get_input_category(input)
    # Categories
    # 0 pending "p"
    # 1 pending+finished (All) "a"
    # 2 finished "f"
    
    case input.inspect
    when '"p"'
      return 0
    when '"a"'
      return 1
    when '"f"'
      return 2
    else
      return -1
    end

  end
 
end