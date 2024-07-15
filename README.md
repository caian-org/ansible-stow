[![Tests][workflows-shield]][workflows-url]
[![GitHub tag][tag-shield]][tag-url]

# ansible-stow

<img src="logo.svg" height="270px" align="right"/>

An Ansible module that interacts with [GNU Stow][stow] packages.

[stow]: https://www.gnu.org/software/stow

[workflows-shield]: https://img.shields.io/github/actions/workflow/status/caian-org/ansible-stow/tests.yml?branch=master&label=tests&logo=github&style=for-the-badge
[workflows-url]: https://github.com/caian-org/ansible-stow/actions/workflows/tests.yml

[tag-shield]: https://img.shields.io/github/tag/caian-org/ansible-stow.svg?logo=git&logoColor=FFF&style=for-the-badge
[tag-url]: https://github.com/caian-org/ansible-stow/releases


## Table of Contents

- [Compatibility](#compatibility)
  - [Development](#development)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
  - [Options](#options)
  - [Examples](#examples)
  - [Caveats](#caveats)
- [Acknowledgements](#acknowledgements)
- [License](#license)


## Compatibility

This ansible module is tested against the following versions:

 | Program   | Compatible versions                                                       |
 | --------- | ------------------------------------------------------------------------- |
 | `ansible` | `2.10.7`, `3.4.0`, `4.10.0`, `5.10.0`, `6.7.0`, `7.7.0`, `8.7.0`, `9.7.0` |
 | `python`  | `3.6.x`, `3.7.x`, `3.8.x`, `3.9.x`, `3.10.x`, `3.11.x`, `3.12.x`          |
 | `stow`    | `2.3.1`, `2.4.0`                                                          |

For `python < 3` (legacy systems that still uses `2.x`), use the [`v0.1.3`][ansible-stow-legacy] of this module.

### Development

For linting and other code verifications, `python >= 3.10` is required.


## Dependencies

To use `ansible-stow`, the managed node should have `stow` installed.

__GNU Stow__ is widely available in all major distributions and can be
installed with `apt-get`, `pacman`, `yum` etc.


## Installation

Download the module and move it into your global Ansible library or into the
library directory alongside your top-level playbook. E.g.:

```sh
$ wget https://raw.githubusercontent.com/caian-org/ansible-stow/v1.1.3/stow
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
          <li>supress</li>
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

# loop through list of packages
- stow:
    state: latest
    package: '{{ item }}'
    dir: /media/user/dots
  with_items:
    - zsh
    - tmux
    - i3
```

### Caveats

- If the package target already exists on the node filesystem as a file or a
  symbolic link, the `supress` state will delete/unlink the target and then
  stow the package.
- If the package target already exists and is a directory, `ansible-stow` will
  fail -- even using the `supress` state. This is an implementation decision.
- Stow cannot handle the tilde expansion (`~`). Use the `$HOME` environment
  variable instead or Ansible's template function `lookup`.


## Acknowledgements

Original implementation by [Ric da Silva][rsilva].

[rsilva]: https://github.com/rmhsilva


## License

To the extent possible under law, [Caian Ertl][me] has waived __all copyright
and related or neighboring rights to this work__. In the spirit of _freedom of
information_, I encourage you to fork, modify, change, share, or do whatever
you like with this project! [`^C ^V`][kopimi]

[![License][cc-shield]][cc-url]

[me]: https://github.com/upsetbit
[cc-shield]: https://forthebadge.com/images/badges/cc-0.svg
[cc-url]: http://creativecommons.org/publicdomain/zero/1.0

[kopimi]: https://kopimi.com

[ansible-stow-legacy]: https://github.com/caian-org/ansible-stow/tree/v0.1.3
