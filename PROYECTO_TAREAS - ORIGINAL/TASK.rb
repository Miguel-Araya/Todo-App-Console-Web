require "date"
require_relative "SHAPE.rb"
require_relative "CONSOLE_CONTROLLER.rb"

class Task

 def initialize(task_file)
    @file = task_file
    @@temp_file = "TEMP_FILE.txt"
    @size = calc_size()
    @@shape = Shape.new
    @@console = Console_controller.instance
    @separate_symbol = "~"
 end
  
  def get_pending_byte
    save_byte = []
    quantity_byte = 0

    File.open(@file, "r") do |file|

      while (line = file.gets)

        if !is_mark(line)
          save_byte.push(quantity_byte)
        end

        quantity_byte += line.bytesize + 1
      end
    end

    return save_byte
  end


  def get_finished_pending_byte
    # The bytes of the lines for each page to avoid
    # comparing with other lines
    save_byte = []
    quantity_byte = 0
  
    File.open(@file, "r") do |file|
      while (line = file.gets)
        save_byte.push(quantity_byte)
        quantity_byte += line.bytesize + 1
      end
    end
  
    return save_byte
  end
  
  def get_finished_byte
    # The bytes of the lines for each page to avoid
    # comparing with other lines
    save_byte = []
    quantity_byte = 0
  
    File.open(@file, "r") do |file|
      while (line = file.gets)

        if is_mark(line)
          save_byte.push(quantity_byte)
        end
  
        quantity_byte += line.bytesize + 1
      end
    end
  
    return save_byte
  end
  
  def pagination_byte(save_byte, page)
    if isEmpty
      @@console.cancel_message("The file is empty")
      return
    end
  
    # When save_line is empty
    if page < 0
      @@console.cancel_message("Not exists tasks to continue")
      return
    end
  
    num_task = page * @@console.size_show_line
  
    File.open(@file, "r") do |file|
      save_byte.each do |start_byte|
        file.seek(start_byte, IO::SEEK_SET)
        line = file.gets
        task = get_task(line)
        num_task += 1
        
        if is_mark(line)

          @@shape.mark_task("#{num_task}) #{task}")

        else
          
          @@shape.unmark_task("#{num_task}) #{task}")

        end

      end
    end
  end
  
  def delete_specific(index)

    return if !exists(index)
  
    count_line = 0
  
    # to access directly the array of each line of the file
    index = index - 1
  
    File.open(@file, "r") do |file|
      File.open(@@temp_file, "w") do |temp_file|
        while count_line < index
          temp_file.write(file.gets)
          count_line += 1
        end
  
        file.gets
  
        while (line = file.gets)
          temp_file.write(line)
        end
      end
    end
  
    File.rename("#{@@temp_file}", "TEMP.txt")
  
    File.rename("#{@file}", "#{@@temp_file}")
  
    File.rename("TEMP.txt", "#{@file}")
  
    # make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      temp_file.write("")
    end
  
    @size -= 1
  
    @@console.confirm_message("Delete correctly")
    
  end
  
  def delete_line(partial_line)
    count_line = 1
    num_line = 0
  
    File.open(@file, "r") do |file|
      File.open(@@temp_file, "w") do |temp_file|
        for i in 0..partial_line.size-1
          num_line = partial_line[i]
  
          while count_line < num_line
            temp_file.write(file.gets)
            count_line += 1
          end 
  
          file.gets
          count_line += 1

        end
  
        while (line = file.gets)
          temp_file.write(line)
        end
      end
    end
  
    File.rename("#{@@temp_file}", "TEMP.txt") 
  
    File.rename("#{@file}", "#{@@temp_file}")
  
    File.rename("TEMP.txt", "#{@file}")
  
    # make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      temp_file.write("")
    end 
  
    @size -= partial_line.size
  
    @@console.confirm_message("Delete correctly")

  end
  
  def add(task)
	
    if task.length <= 0
      
      @@console.cancel_message("You can not insert a void task")	
          
      return
    end

    File.open(@file, "a") do |file|
      file.write ("#{task} Fecha: #{Date.today.strftime("%d/%m/%Y")}\n")
    end
    
    #confirm the add
    @@console.confirm_message("Task added correctly")
     
    @size += 1

  end

  #NEEDS TO BE MODIFIED. IT IS USELESS.
  def update_byte(save_line, content, index)
    
    #implement the method

  end
  
  #repair the problem when a task is done (mark)
  def update_line(index, content)
    
    include_date = false
  
    # make other restriction that cannot only include a date
    if content.length <= 0
      @@console.cancel_message("You can not insert a void task")	
      return
    end
  
    include_date = content.include?("Fecha:")
      
    if include_date && !is_valid_date(content.split("Fecha:")[-1].strip)
      @@console.cancel_message("Not valid format for the date")
      return
    end
  
    if include_date && content.split("Fecha:")[0] == ""
      @@console.cancel_message("Not valid format of the task")
      return
    end
    
    date = ""
    status_task = ""
    count_line = 1
  
    File.open(@file, "r") do |file|
      File.open(@@temp_file, "w") do |temp_file|
        while count_line < index
          temp_file.write(file.gets)
          count_line += 1
        end
  
        line = file.gets
  
        if is_mark(line)
          status_task = "#{@separate_symbol}done" 
        end       
  
        # Proof that really exists the Fecha: al final
        if !include_date
          line = get_task(line)
          date = " Fecha: #{line.split("Fecha:")[-1].strip}"
        end
  
        temp_file.write("#{content}#{date}#{status_task}\n") 
  
        while (line = file.gets)
          temp_file.write(line)
        end
      end
    end
  
    File.rename("#{@@temp_file}", "TEMP.txt") 
    File.rename("#{@file}", "#{@@temp_file}")
    File.rename("TEMP.txt", "#{@file}")
  
    # make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      temp_file.write("")
    end
  
    # use to modify the string passed in the function
    content.replace("#{content}#{date}#{status_task}")
  
    @@console.confirm_message("Update correctly")
  end
     
  def get_pending_line

    save_line = []

    index_line = 1

    File.open(@file, "r") do |file|
      
      while (line = file.gets)
       
        if !is_mark(line) 

          save_line.push(index_line)
            
        end

        index_line += 1

      end
             
    end

    return save_line

  end

  def get_finished_line

    save_line = []

    index_line = 1

    File.open(@file, "r") do |file|
      
      while (line = file.gets)
       
        if is_mark(line) 
          
          save_line.push(index_line)
            
        end

        index_line += 1

      end
             
    end
    
    return save_line

  end

  def get_finished_pending_line

    save_line = []

    index_line = 1

    File.open(@file, "r") do |file|
      
      while (line = file.gets)
           
        save_line.push(index_line)
          
        index_line += 1

      end
             
    end

    return save_line

  end

  def get_line_partial(save_line, content)
    index_line = 1
    partial_line = []
    content = content.downcase
    line = ""
  
    File.open(@file, "r") do |file|
      for i in 0..save_line.size-1
        while index_line < save_line[i]
          file.gets
          index_line += 1
        end
  
        line = file.gets
        task = get_task(line)
  
        if task.downcase.include?(content)
          partial_line.push(index_line)
        end
  
        index_line += 1
      end
    end
  
    return partial_line
  end
  
  def get_byte_partial(save_byte, content)
    
    partial_byte = []
 
    content = content.downcase
 
    line = ""
 
    #make test doing file and across that part. guide
    #with the pagination byte function
    File.open(@file, "r") do |file|
 
      save_byte.each do |start_byte|

        file.seek(start_byte, IO::SEEK_SET)

        line = file.gets 
 
        task = get_task(line)
 
        if task.downcase.include?(content) 
 
          partial_byte.push(start_byte)
 
        end

      end
 
    end
   
    return partial_byte
 
  end

  def status_task(page)
    if isEmpty
      @@console.cancel_message("The file is empty")
      return
    end
  
    # Quantity of tasks that show per page standard in console
    start_line = page * @@console.size_show_line
    end_line = start_line + @@console.size_show_line
  
    difference_start = @size - start_line
    start_line += difference_start if difference_start < 0
  
    difference_end = @size - end_line
    end_line += difference_end if difference_end < 0
  
    count = 0
  
    File.open(@file, "r") do |file|
      while count < start_line
        file.gets
        count += 1
      end
  
      while count < end_line
        line = file.gets
        task = get_task(line)
  
        if is_mark(line)
          @@shape.mark_task("#{count + 1}-> " + task.strip)
        else
          @@shape.unmark_task("#{count + 1}-> " + task.strip)
        end
  
        count += 1
      end
    end
  end
    
  def pagination_line(save_line, page)
    if isEmpty
      @@console.cancel_message("The file is empty")
      return
    end
  
    # When save_line is empty
    if page < 0
      @@console.cancel_message("Not exists tasks to continue")
      return
    end
  
    num_task = page * @@console.size_show_line
    count_line = 1
  
    File.open(@file, "r") do |file|
      save_line.each do |start_line|
        while count_line < start_line
          file.gets
          count_line += 1
        end
  
        line = file.gets
        task = get_task(line)
  
        num_task += 1
        
        if is_mark(line)

          @@shape.mark_task("#{num_task}) #{task}")

        else
          
          @@shape.unmark_task("#{num_task}) #{task}")

        end
  
        count_line += 1
      end
    end
  end
    
  def mark_line(partial_line)
    count_line = 1
    num_line = 0
  
    File.open(@file, "r") do |file|
      File.open(@@temp_file, "w") do |temp_file|
        for i in 0..partial_line.size-1
          num_line = partial_line[i]
          while count_line < num_line
            temp_file.write(file.gets)
            count_line += 1
          end
  
          line = file.gets
          temp_file.write("#{line.strip}#{@separate_symbol}done\n")
          count_line += 1
        end
  
        while (line = file.gets)
          temp_file.write(line)
        end
      end
    end
  
    File.rename("#{@@temp_file}", "TEMP.txt")
    File.rename("#{@file}", "#{@@temp_file}")
    File.rename("TEMP.txt", "#{@file}")
  
    # Make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      temp_file.write("")
    end
  
    @@console.confirm_message("Mark tasks as done correctly")
  end
  
  def unmark_line(partial_line)
    count_line = 1
    num_line = 0
  
    File.open(@file, "r") do |file|
      File.open(@@temp_file, "w") do |temp_file|
        for i in 0..partial_line.size-1
          num_line = partial_line[i]
          while count_line < num_line
            temp_file.write(file.gets)
            count_line += 1
          end
  
          line = file.gets
          task = get_task(line)
          temp_file.write("#{task.strip}\n")
          count_line += 1
        end
  
        while (line = file.gets)
          temp_file.write(line)
        end
      end
    end
  
    File.rename("#{@@temp_file}", "TEMP.txt")
    File.rename("#{@file}", "#{@@temp_file}")
    File.rename("TEMP.txt", "#{@file}")
  
    # Make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      temp_file.write("")
    end
  
    @@console.confirm_message("Unmark tasks correctly")
  end
  
  def calc_size
    
    size = 0
    
    File.foreach(@file) do |line|
      size += 1
    end 

    return size

  end
  
  def get_size
    return @size
  end
  
  def isEmpty
   
    if @size <= 0
      return true
    end
   
    return false
  end
   
  def exists(index)

    if index > @size or index <= 0

      return false
    end

    return true
  
  end

  def delete_set(save_line, set_task)

    if(set_task.empty?)

      @@console.cancel_message("The set of tasks is empty")

      return

    end

    count_line = 1

    num_line = 0
 
    File.open(@file, "r") do |file|
     
      File.open(@@temp_file, "w") do |temp_file|

        for i in 0..set_task.size-1

          num_line = save_line[set_task[i]-1]
          
          while count_line < num_line
          
            temp_file.write(file.gets)       
 
            count_line += 1
 
          end 

          file.gets

          count_line += 1

        end

        while (line = file.gets)
         
          temp_file.write(line)     

        end

      end
   
    end
   
    File.rename("#{@@temp_file}", "TEMP.txt") 

    File.rename("#{@file}", "#{@@temp_file}")

    File.rename("TEMP.txt", "#{@file}")

    #make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      
      temp_file.write("")       
 
    end 
 
    #its necessary eliminate the duplicate values for this part
    #can cause elminate values that not real exists
    @size -= set_task.size

    @@console.confirm_message("Delete correctly") 

  end

  def delete_range(save_line)
    count_line = 1
    num_line = 0
  
    File.open(@file, "r") do |file|
      File.open(@@temp_file, "w") do |temp_file|
        for i in 0..save_line.size-1
          num_line = save_line[i]
          while count_line < num_line
            temp_file.write(file.gets)
            count_line += 1
          end
  
          file.gets
          count_line += 1
        end
  
        while (line = file.gets)
          temp_file.write(line)
        end
      end
    end
  
    File.rename("#{@@temp_file}", "TEMP.txt")
    File.rename("#{@file}", "#{@@temp_file}")
    File.rename("TEMP.txt", "#{@file}")
  
    # Make the temp file free of all the lines
    File.open(@@temp_file, "w") do |temp_file|
      temp_file.write("")
    end
  
    @size -= save_line.size
  
    @@console.confirm_message("Delete correctly")

  end
  
  def binary_search(save_line, value)
    left = 0
    right = save_line.size - 1
    middle = ((left + right) / 2).to_i
  
    while (save_line[middle] != value)
      if (left > right)
        middle = -1
        break
      end
  
      if value > save_line[middle]
        left = middle + 1
      end
  
      if value < save_line[middle]
        right = middle - 1
      end
  
      middle = ((left + right) / 2).to_i
    end
  
    return middle
  end
  
  #The list must be sorted
  def delete_duplicate_sort(set_task)

    value = nil
    new_set_task = []

    set_task.each do |element|

      if element != value

        value = element
        new_set_task.push(value)
         
      end

    end

    return new_set_task
  end

  def is_valid_date(date)

    #valid date -> 12/12/2024 length(10)
    
    return false if date.length != 10

    date.split("/").each do |element|

      return false if element.to_i == 0

    end

    return true

  end

  def is_mark(line)
    split = line.split(@separate_symbol)
      
    return split[-1].strip == "done" 
  end

  #this provide the task if have ~done in multiples parts of the text
  def get_task(line)
    
    line = line.strip

    line = line.split("#{@separate_symbol}done")

    task = ""	

    pieceTask = 0
    
    if line.size >= 1
   
      task += line[0]
      pieceTask += 1 
    end
  
    while pieceTask <= line.size-1

      task += "#{@separate_symbol}done#{line[pieceTask]}"
      pieceTask+=1
    end
    
    return task
  end

  def to_string
    
    File.open(@file, "r") do |file|
      puts file.read()
    end

  end 
 
  #include ListInterface
end
