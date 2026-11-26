{
  config,
  lib,
  pkgs,
  ...
}:
let
  dictionariesDir = "${config.xdg.dataHome}/goldendict/dictionaries";
  configure = pkgs.writeText "configure-goldendict.py" ''
    from pathlib import Path
    import xml.etree.ElementTree as ET

    config_file = Path(${builtins.toJSON "${config.xdg.configHome}/goldendict/config"})
    tree = ET.parse(config_file) if config_file.exists() else ET.ElementTree(ET.Element("config"))
    root = tree.getroot()
    paths = root.find("paths")
    if paths is None:
        paths = ET.SubElement(root, "paths")
    directory = ${builtins.toJSON dictionariesDir}
    if not any(path.text == directory for path in paths.findall("path")):
        ET.SubElement(paths, "path", recursive="1").text = directory
        config_file.parent.mkdir(parents=True, exist_ok=True)
        ET.indent(tree, space=" ")
        tree.write(config_file, encoding="utf-8")
  '';
in
{
  home.packages = [ pkgs.goldendict-ng ];

  xdg.dataFile."goldendict/dictionaries/ecdict".source = pkgs.ecdict-stardict;

  home.activation.goldendict = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.python3}/bin/python3 ${configure}
  '';
}
