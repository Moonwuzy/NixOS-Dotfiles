{ pkgs, ... }:

{
  services.vice.package =
    pkgs.vice-clipper.overridePythonAttrs (old: {
      doCheck = false;
    });
}
