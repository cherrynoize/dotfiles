function fish_user_key_bindings
  # Enable vi mode
  fish_vi_key_bindings
  # Fix CTRL+F autocompletion break
  bind -M insert \cf forward-char

  # Disable retard ctrl-v and replace with key reader
  bind --preset \cv 'fish_key_reader'
  bind -M insert --preset \cv 'fish_key_reader'
end
