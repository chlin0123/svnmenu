# svnmenu
## Summary
svnmenu is a simple tool that allows you to do svn diff/annotate/log in vim windows, so it's
extremely easy to check these commonly used info and view/pick up diffs in a vimdiff window.

## Installation
cd ~/.vim/plugin  
git clone https://github.com/chlin0123/svnmenu.git

## Usage
### Quick Guide
| Shortcut | Command                              |
|----------|--------------------------------------|
| ,sd      | svn diff                             |
| ,sn      | svn annotate                         |
| ,sl      | svn log                              |
| ,sp      | svn diff HEAD^ (diff to the parent)  |
| q        | close the window                     |

### Windows
After using the above shortcuts, svnmenu will open a horzontal or vertical split window with the 
requested output. Type `CTRL-W w` to move between windows, and type `q` in the the new window to 
close it. You may also type `:h window-move-cursor` to learn more about moving between windows.

### Working on diffs
`,gd` or `,gp` opens a new window in diff mode, so you can easily get/move diff chunks between
the two windows. You should only modify the original window, not the new window created by svnmenu 
created since it doesn't map to any real file. If you want to revert a diff chunk to the svn repo 
version, you may type move your cursor to the target diff in the original window, and then type 
`do`. You may type `:h copy-diffs` for more information about copying diff sections between windows.

### Finding commit message for a source line
If you want to find the commit message for a source line, you can first use `,gn` to open an 
annotate window which shows the short version commit hash id of each source line, and then use `,gl`
to open svn log for the commit messages. Move the cursor to the desired short commit hash id and 
type `g*` or `g#` to perform a partial-word search, and then move to the log window to see the 
result. Don't use the whole-word seach `*` or `#` otherwise the long version commit hash id in the 
annotate window won't be considered as a matche. Type `:h g*` in your vim for more details.
