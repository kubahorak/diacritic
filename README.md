Diacritic
=========

Vim plugin to transliterate from alphabet with diacritics into latin alphabet.
Or put simply: it **removes diacritics**.

Transliteration can be illustrated by the following example. Suppose you have a
Czech text:

    Příliš žluťoučký kůň úpěl ďábelské ódy.

Then the transliterated text without diacritics is:

    Prilis zlutoucky kun upel dabelske ody.

Installation
------------

- ### Using [Pathogen](https://github.com/tpope/vim-pathogen)

  Clone this repository to your `.vim/bundle` directory, for example:
  
      cd ~/.vim/bundle
      git clone https://github.com/kubahorak/diacritic.git

- ### Manually

  Download the zip file and extract its contents into your `.vim` directory.

Usage
-----

Use command `<leader>p` in visual mode, visual block mode or use it with
standard motion operators.

E.g. `<leader>p3e` removes diacritics from the next 3 words.

You can also use ex command `:DiacriticTranslit` to transliterate the whole
line or range of lines.

For more information please refer to the Vim help page.

License
-------

MIT License. Copyright (c) 2014 Jakub Horák
