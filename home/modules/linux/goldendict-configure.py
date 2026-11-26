import sys
from pathlib import Path
import xml.etree.ElementTree as ET

config_file = Path(sys.argv[1])
tree = ET.parse(config_file) if config_file.exists() else ET.ElementTree(ET.Element("config"))
root = tree.getroot()
paths = root.find("paths")
if paths is None:
    paths = ET.SubElement(root, "paths")
directory = sys.argv[2]
if not any(path.text == directory for path in paths.findall("path")):
    ET.SubElement(paths, "path", recursive="1").text = directory
    config_file.parent.mkdir(parents=True, exist_ok=True)
    ET.indent(tree, space=" ")
    tree.write(config_file, encoding="utf-8")
