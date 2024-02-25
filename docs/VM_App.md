# VM App

--

In the `p2vagrant` folder there's a file called `vm` which is the main script of an application to help manage your VM. Usage is...

```
./vm [-g] [-r] [-v] [<integer>]
```
* `<integer>` is the index of a provisioning step (a step).
* `<integer>` must always less than or equal to the last index.
* In some cases one or more of the following rules apply...

1. `<integer>` **must** the index for a step that requires a new `Vagrantfile`.
2. `<integer>` that evaluates to `0` is the same as `1`.

Flag | Argument | About
---- | -------- | -----
`-g` | `<integer>` | Generates a new `Vagrantfile` if `<integer>` matches rule 1. Exits with `error` otherwise.
`-r` | `<integer>` | Resets the files in `p2vagrant` to a state immediately *before* the specified step. `-g` is always implicit with `-r`.
`-r` | `0` or none | zzzzz zzzzz zzzzz.
`-v` | `0` or none | Runs `vagrant up` if a `Vagrantfile` is found. Exits with `error` otherwise.
`-v--` | `<integer>` | `-v` with any other flag  `-g <integer>` then runs `vagrant up --provision`.

```
./vm 
Usage: ./vm [-g] [-r] [-v] <integer>
Options:
  -g    Generate Vagrantfile based on the specified integer.
  -r    Reset: Delete any generated or copied files from earlier Vagrant provisioning.
  -v    Run `vagrant up` after generating the Vagrantfile.
  <integer>   Step number for Vagrantfile generation.
--
Usage examples:
  ./vm -g <integer>    # Generate Vagrantfile based on the specified integer.
  ./vm -r              # Reset: Delete any file generated or copied in earlier Vagrant provisioning.
  ./vm -r <integer>    # Reset and generate Vagrantfile based on the specified integer.
  ./vm -v <integer>    # Generate Vagrantfile based on the specified integer then run `vagrant up`.
  ./vm -gr <integer>   # Reset and generate Vagrantfile based on the specified integer.
  ./vm -gv <integer>   # Generate Vagrantfile based on the specified integer then run `vagrant up`.
  ./vm -rv <integer>   # Reset and generate Vagrantfile based on the specified integer then run `vagrant up`.
  ./vm -grv <integer>  # Reset and generate Vagrantfile based on the specified integer then run `vagrant up`.

  -g is implied any time an integer argument is given, so only serves as
     'syntactic sugar' to make the intended use of './vm' explicitly clear.
  -g & -v are both invalid with a valid integer argument.
```

## Variables

zzzzz zzzzz zzzz

```
zzzzz zzzzz zzzz
```

zzzzz zzzzz zzzz

--

[**Back to Steps**](../README.md)

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
