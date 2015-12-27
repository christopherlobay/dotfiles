function right_prompt_segment -a "content" "color" -d "Print a segment of your right prompt"
  if [ -n $color ]
    set_color $color
  else
    set_color normal
  end

  echo -ns " "$content

  set_color normal
end

function current_git_files -d "Print your current git files"
  git_is_repo; and begin
    set -l modified (count (git ls-files --m))
    set -l untracked (count (git ls-files --other --exclude-standard))
    if [ $modified -ge 1 ]
      right_prompt_segment $modified" modified" yellow
    end
    if [ $untracked -ge 1 ]
      right_prompt_segment $untracked" untracked" green
    end
  end
end

function fish_right_prompt -d "Render your right prompt"
  current_git_files
end
