# ansible-stow

An Ansible module that interacts with [GNU Stow][stow] packages.

<img src="docs/logo.png" height="300px" align="right"/>

[stow]: https://www.gnu.org/software/stow


## Dependencies

To use `ansible-stow`, the managed node should have `stow` installed.

GNU Stow is widely available in all major distributions and can be installed
with `apt-get`, `pacman`, `yum` etc.


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
      <td>Lorem</td>
    </tr>
    <tr>
      <td><code>target</code></td>
      <td><strong>no</strong></td>
      <td></td>
      <td>Ipsum</td>
    </tr>
    <tr>
      <td><code>dir</code></td>
      <td><strong>yes</strong></td>
      <td></td>
      <td>Sit</td>
    </tr>
    <tr>
      <td><code>state</code></td>
      <td><strong>yes</strong></td>
      <td>
        <ul>
          <li>absent</li>
          <li>latest</li>
          <li>present</li>
          <li>supress</li>
        </ul>
      </td>
      <td>Dolor</td>
    </tr>
  </tbody>
</table>


## Examples

```yaml

# stow package "zsh" of directory "/media/user/dots" to the home directory
- stow:
    state: present
    package: zsh
    dir: /media/user/dots
    target: ~

# remove package "tmux"
- stow:
    state: absent
    package: tmux
    dir: /media/user/dots
    target: ~

# in case of conflict, overwrite file with symlink
- stow:
    state: supress
    package: vim
    dir: /media/user/dots

```


## Acknowledgements

Original implementation:

- [`stow.py`][stow] by [Ric da Silva][rsilva]

[stow]: https://github.com/rmhsilva/dotfiles/blob/master/library/stow.py
[rsilva]: https://github.com/rmhsilva
