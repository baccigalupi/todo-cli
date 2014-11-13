class TodoApp < CommandLineApp
  attr_reader :projects, :tasks, :view

  def initialize(input, output)
    @input = input
    @view = View.new(output)
    @projects = []
    @tasks = []
  end

  def get_input
    gets.chomp
  end

  extend Forwardable

  def_delegators :view,
    :print_project_menu,
    :print_task_menu,
    :print_task_menu,
    :print_projects_list,
    :print_tasks_list,
    :print_project_create_prompt,
    :print_project_delete_prompt,
    :print_project_rename_prompt,
    :print_project_rename_prompt,
    :print_prompt_for_new_project_name,
    :print_project_edit_prompt,
    :print_task_edit_prompt,
    :print_prompt_for_new_task_name,
    :print_new_task_prompt,
    :print_task_not_here_message

  # M, projects collection
  def project_add(name)
    projects << name
  end

  def project_delete(name)
    if project_present?(name)
      projects.delete(name)
    end
  end

  def project_present?(name)
    projects.include?(name)
  end

  def project_rename(old_name, new_name)
    projects.delete(old_name)
    projects << new_name
  end

  # M, tasks collection
  def add_task(name)
    tasks << name
  end

  def task_present?(name)
    tasks.include?(name)
  end

  def task_rename(old_name, new_name)
    tasks.delete(old_name)
    tasks << new_name
  end

  def complete_task(name)
    tasks.delete(name)
    completed_task = "#{name}: completed"
    tasks << completed_task
  end

  # router
  def run
    run_project_menu
  end

  def run_project_menu
    print_project_menu

    welcome_menu = true

    while welcome_menu
      input = get_input

      if input == 'list'
        print_projects_list(projects)
      elsif input == 'create'
        print_project_create_prompt
        project_add(get_input)
        print_project_menu
      elsif input == 'delete'
        print_project_delete_prompt
        project_delete(get_input)
      elsif input == 'rename'
        print_project_rename_prompt
        if project_present?(old_name = get_input)
          print_prompt_for_new_project_name
          project_rename(old_name, get_input)
        end
      elsif input == 'edit'
        print_project_edit_prompt
        project_name = get_input
        if project_present?(project_name)
          run_task_menu(project_name)
          print_task_menu(project_name)
        end
      elsif input == 'quit'
        welcome_menu = false
      end
    end
  end

  def run_task_menu(project_name)
    print_task_menu(project_name)

    task_menu = true

    while task_menu
      task_input = get_input
      if task_input == 'list'
        print_tasks_list(tasks)
      elsif task_input == 'create'
        print_new_task_prompt
        add_task(get_input)
      elsif task_input == 'edit'
        print_task_edit_prompt
        old_name = get_input
        if task_present?(old_name)
          print_prompt_for_new_task_name
          task_rename(old_name, get_input)
        else
          print_task_not_here_message(old_name)
        end
      elsif task_input == 'complete'
        complete_task = get_input
        if task_present?(complete_task)
          complete_task(complete_task)
        else
          print_task_not_here_message(complete_task)
        end
      elsif task_input == 'back'
        print_project_menu
        task_menu = false
      end
    end
  end

  def real_puts message = ""
    $stdout.puts message
  end
end
