# ansible-stow

<img src="docs/logo.png" height="300px" align="right"/>

An Ansible module that interacts with [GNU Stow][stow] packages.

[![Code Quality][lgtm-shield]][lgtm-url]

[stow]: https://www.gnu.org/software/stow
[lgtm-shield]: https://img.shields.io/lgtm/grade/python/g/caian-org/ansible-stow.svg?style=for-the-badge
[lgtm-url]: https://lgtm.com/projects/g/caian-org/ansible-stow/context:python


## Table of Contents

- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
  - [Options](#options)
  - [Examples](#examples)
  - [Caveats](#caveats)
- [License](#license)
- [Acknowledgements](#acknowledgements)


## Dependencies

To use `ansible-stow`, the managed node should have `stow` installed.

__GNU Stow__ is widely available in all major distributions and can be
installed with `apt-get`, `pacman`, `yum` etc.


## Installation

Download the module and move it into your global Ansible library or into the
library directory alongside your top-level playbook. E.g.:

```sh
$ wget https://git.io/fjlZ4
$ (sudo) mv stow /usr/share/ansible
```


## Usage

### Options

<table>
  <tbody>
    <tr>
      <th align="center">Parameter</th>
      <th align="center">Required</th>
      <th align="center">Choices / Defaults</th>
      <th align="center">Comments</th>
    </tr>
    <tr>
      <td><code>package</code></td>
      <td><strong>yes</strong></td>
      <td></td>
      <td>Name of the Stow package</td>
    </tr>
    <tr>
      <td><code>target</code></td>
      <td><strong>no</strong></td>
      <td><strong>Default:</strong> user's home directory</td>
      <td>Path of target directory to perform</td>
    </tr>
    <tr>
      <td><code>dir</code></td>
      <td><strong>yes</strong></td>
      <td></td>
      <td>Path of the Stow directory</td>
    </tr>
    <tr>
      <td><code>state</code></td>
      <td><strong>yes</strong></td>
      <td>
        <strong>Choices:</strong><br>
        <ul>
          <li>absent</li>
          <li>latest</li>
          <li>present</li>
          <li>supress</li>bla
        </ul>
      </td>
      <td>
        <ul>
          <li><strong>absent:</strong> unstow / delete the package. Equivalent to <code>stow --delete</code>.</li>
          <li><strong>latest:</strong> first unstow a package, then stow again. Equivalent to <code>stow --restow</code>.</li>
          <li><strong>present:</strong> stow a package. Equivalent to <code>stow --stow</code>.</li>
          <li><strong>supress:</strong> stow a package and overwrite the file if any conflict is found. <strong>THIS CAN LEAD TO DATA LOSS!</strong> Use wisely.</li>
	</ul>
      </td>
    </tr>
  </tbody>
</table>


### Examples

```yaml

# stow package "zsh" of directory "/media/user/dots" to the home directory
- stow:
    state: present
    package: zsh
    dir: /media/user/dots
    target: '$HOME'

# remove package "tmux"
- stow:
    state: absent
    package: tmux
    dir: /media/user/dots

# in case of conflict, overwrite the file with a symlink
- stow:
    state: supress
    package: vim
    dir: /media/user/dots

```

### Caveats

- If the package target already exists on the node filesystem as a file or a
  symbolic link, the `supress` state will delete/unlink the target and then
  stow the package.
- If the package target already exists and is a directory, `ansible-stow` will
  fail -- even using the `supress` state. This is an implementation decision.
- Stow cannot handle the tilde expansion (`~`). Use the `$HOME` environment
  variable instead or Ansible's template function `lookup`.


## License

To the extent possible under law, [Caian Rais Ertl][me] has waived all
copyright and related or neighboring rights to this work.

[![License][cc-shield]][cc-url]

[me]: https://github.com/caiertl
[cc-shield]: https://forthebadge.com/images/badges/cc-0.svg
[cc-url]: http://creativecommons.org/publicdomain/zero/1.0


## Acknowledgements

Original implementation:

- [`stow.py`][stow] by [Ric da Silva][rsilva]

[stow]: https://github.com/rmhsilva/dotfiles/blob/master/library/stow.py
[rsilva]: https://github.com/rmhsilva
