function prompt_segment -a "content" "color" -d "Print a segment of your prompt"
  if test -n $color
    set_color $color
  else
    set_color normal
  end

  echo -ns $content" "

  set_color normal
end

function current_directory -d "Print your current directory"
  prompt_segment (prompt_pwd) white
end

function current_git_branch -d "Print your current git branch"
  if git_is_repo
    if git_is_touched
      prompt_segment (git_branch_name) yellow
    else
      prompt_segment (git_branch_name) green
    end
  end
end

function fish_prompt -d "Render your left prompt"
  current_directory
  current_git_branch
end
