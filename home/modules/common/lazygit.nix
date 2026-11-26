{ theme, ... }:
{
  programs.lazygit = {
    enable = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = {
      os = {
        edit = "\${EDITOR:-ms} -- {{filename}}";
        editAtLine = "\${EDITOR:-ms} -- {{filename}}:{{line}}";
        editAtLineAndWait = "\${EDITOR:-ms} -- {{filename}}:{{line}}";
        openDirInEditor = "\${EDITOR:-ms} -- {{dir}}";
        editInTerminal = true;
      };
      gui.theme = with theme.palette; {
        activeBorderColor = [
          green
          "bold"
        ];
        inactiveBorderColor = [ grey0 ];
        searchingActiveBorderColor = [ yellow ];
        optionsTextColor = [ blue ];
        selectedLineBgColor = [ bg2 ];
        cherryPickedCommitFgColor = [ aqua ];
        cherryPickedCommitBgColor = [ bg_green ];
        unstagedChangesColor = [ red ];
        defaultFgColor = [ fg ];
      };
      keybinding = {
        universal = {
          prevBlock-alt = "j";
          nextItem-alt = "k";
          prevItem-alt = "l";
          nextBlock-alt = ";";
          scrollLeft = "J";
          scrollDownMain-alt1 = "K";
          scrollUpMain-alt1 = "L";
          scrollRight = "H";
        };
        commits = {
          moveDownCommit = [
            "<ctrl+k>"
            "<alt-down>"
          ];
          moveUpCommit = [
            "<ctrl+l>"
            "<alt-up>"
          ];
          openLogMenu = "<ctrl+h>";
        };
        main = {
          prevHunk = [
            "<left>"
            "j"
          ];
          nextHunk = [
            "<right>"
            ";"
          ];
        };
      };
    };
  };
}
