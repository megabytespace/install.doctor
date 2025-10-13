# Firejail

Firejail integration is pending. Firejail will allow us to improve security on Linux platforms by sandboxing executables and programs. Firejail already includes hundreds of definitions for programs. There are also custom lists maintained by the community which can be found on the [Firejail README](https://github.com/netblue30/firejail).

Ideally, we should create a few generic profiles that handle the following cases:

1. CLIs that don't need access to ~/.ssh and ~/.config etc.
2. CLIs that DO need access to specific folders
3. The configurations should be automatically generated from an array of options for each entry in the `software.yml` file

It would also be great if we could have Firejail automatically load anytime executables are called so that we can run `pnpm` instead of `firejail pnpm`, for instance.
