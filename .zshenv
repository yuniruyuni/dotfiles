case ${OSTYPE} in
  darwin*)
    setopt no_global_rcs
    ;;
  msys*)
    # MSYS2: Enable native Windows symlinks
    export MSYS=winsymlinks:nativestrict
    ;;
  linux*)
    ;;
esac
