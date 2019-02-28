This repository contains code that cannot be made part of fzf.
PRs to add more extensions are welcome!

## Bash Extensions

### `history-exec.bash`

This extension adds the ability to choose between direct execution and prior
editing in CTRL-R for bash.  The keys to choose between execution and editing
are configurable using the environment variables

* `FZF_CTRL_R_EDIT_KEY` (defaults to "enter")
* `FZF_CTRL_R_EXEC_KEY` (defaults to "ctrl-x")

#### Installation

First this repository need to be cloned to some conventient place.
This README will expect this place to be ~/.fzf-plugins for simplicity:

```bash
git clone https://github.com/4z3/fzf-plugins ~/.fzf-plugins
```

Afterwards, `history-exec.bash` can be enabled and configured in your
`.bashrc` like follows:

```bash
# First load fzf stuff as usual.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Then configure and load this plugin.
FZF_CTRL_R_EDIT_KEY=ctrl-e
FZF_CTRL_R_EXEC_KEY=enter
source ~/.fzf-plugins/history.bash
```
