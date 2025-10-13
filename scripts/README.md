# Install Doctor Scripts

The scripts in this folder are linked to from various https://install.doctor URLs. For instance, you can install
Homebrew by running `bash <(curl -sSL https://install.doctor/brew)` which will direct to the `homebrew.sh` file in this
directory.

## Gomplate

All the scripts are generated using `gomplate` so they can include shared partials. To re-generate the scripts ensure `gomplate`
is installed by running `brew install gomplate` and then run `gomplate` in this `scripts/` directory.

## TODO

Pull requests are welcome. If someone wants to add variables to customize anything in the default scripts, please merge your changes back here upstream.