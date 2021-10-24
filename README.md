
## ZSH
### File Tree
- `$HOME`
    - `.zshenv`
        - The first<sup>[1](#ref1)</sup> file read
- `$ZDOTDIR`
    - `env.d`
    - `func.d`
    - `rc.d` 
    - `zshrc.d`
Where `$ZDOTDIR` is set to `"${XDG_CONFIG_HOME:-$HOME/.config}/zsh"` in `$HOME/.zshenv`


### References
- <a name="ref1">1</a> [ZSH Documentation: 5.1 Startup/Shutdown Files](https://zsh.sourceforge.io/Doc/Release/Files.html#Files) 

