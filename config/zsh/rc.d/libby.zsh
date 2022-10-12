# https://github.com/carterprince/libby
# libby is a simple CLI tool to quickly download books from Library Genesis.
# libby filters out all filetypes except ePUBs and PDFs.
# Install: yay -S libby-git

# Usage: libby [--rofi] [--mirror <num>] [--no-view] [--to-kindle] <query>
#   --rofi: use rofi to select a book (default is fzf)
#   --mirror <num>: use an alternative libgen mirror (default: 3)
#   --no-view: don't view the result
#   --to-kindle: convert file to .mobi and send to $KINDLE_EMAIL via mutt/neomutt (implies --no-view)
#   --to-usb: copy file to $USB via rsync (implies --no-view)
#   <query>: the query to search for

# By default, libby assumes $HOME/books (lowercase 'b') exists and saves all downloads there. This can be changed by adding
export LIBBY_OUTPUT_DIR="$HOME/Documents/books"

# By default, libby opens the downloaded file with xdg-open. This command can be changed by adding
export LIBBY_VIEWER="zathura"

