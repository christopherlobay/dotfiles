function fish_prompt
  set -l yellow (set_color yellow)
  set -l green (set_color green)
  set -l normal (set_color normal)

  echo -n -s (prompt_pwd) " "

  if git_is_repo
    if git_is_touched
      echo -n -s $yellow
    else
      echo -n -s $green
    end
    echo -n -s (git_branch_name) $normal " "
  end
end
