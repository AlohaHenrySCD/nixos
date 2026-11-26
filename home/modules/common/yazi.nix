{ theme, ... }:
let
  inherit (theme) palette;
in
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
    theme = {
      app = {
        overall = { bg = palette.bg0; };
      };
      mgr = {
        cwd = { fg = palette.aqua; };
        find_keyword = { fg = palette.yellow; bold = true; underline = true; };
        find_position = { fg = palette.purple; bold = true; };
        symlink_target = { fg = palette.grey1; italic = true; };
        marker_copied = { fg = palette.green; bg = palette.green; };
        marker_cut = { fg = palette.red; bg = palette.red; };
        marker_marked = { fg = palette.aqua; bg = palette.aqua; };
        marker_selected = { fg = palette.yellow; bg = palette.yellow; };
        count_copied = { fg = palette.bg0; bg = palette.green; bold = true; };
        count_cut = { fg = palette.bg0; bg = palette.red; bold = true; };
        count_selected = { fg = palette.bg0; bg = palette.yellow; bold = true; };
        border_style = { fg = palette.bg5; };
      };
      indicator = {
        parent = { fg = palette.fg; bg = palette.bg2; };
        current = { fg = palette.bg0; bg = palette.green; bold = true; };
        preview = { fg = palette.fg; bg = palette.bg2; underline = true; };
      };
      tabs = {
        active = { fg = palette.bg0; bg = palette.green; bold = true; };
        inactive = { fg = palette.grey2; bg = palette.bg2; };
      };
      mode = {
        normal_main = { fg = palette.bg0; bg = palette.green; bold = true; };
        normal_alt = { fg = palette.green; bg = palette.bg2; };
        select_main = { fg = palette.bg0; bg = palette.yellow; bold = true; };
        select_alt = { fg = palette.yellow; bg = palette.bg2; };
        unset_main = { fg = palette.bg0; bg = palette.red; bold = true; };
        unset_alt = { fg = palette.red; bg = palette.bg2; };
      };
      status = {
        overall = { fg = palette.fg; bg = palette.bg1; };
        perm_type = { fg = palette.blue; };
        perm_read = { fg = palette.yellow; };
        perm_write = { fg = palette.red; };
        perm_exec = { fg = palette.green; };
        perm_sep = { fg = palette.grey0; };
        progress_label = { fg = palette.fg; bold = true; };
        progress_normal = { fg = palette.green; bg = palette.bg2; };
        progress_error = { fg = palette.red; bg = palette.bg_red; };
      };
      which = {
        border = { fg = palette.green; };
        mask = { bg = palette.bg1; };
        cand = { fg = palette.aqua; };
        rest = { fg = palette.grey1; };
        desc = { fg = palette.fg; };
        separator_style = { fg = palette.bg5; };
      };
      confirm = {
        border = { fg = palette.green; };
        title = { fg = palette.green; bold = true; };
        body = { fg = palette.fg; };
        list = { fg = palette.fg; };
        btn_yes = { fg = palette.bg0; bg = palette.green; bold = true; };
        btn_no = { fg = palette.fg; bg = palette.bg2; };
      };
      spot = {
        border = { fg = palette.green; };
        title = { fg = palette.green; bold = true; };
        tbl_col = { fg = palette.blue; };
        tbl_cell = { fg = palette.bg0; bg = palette.yellow; };
      };
      notify = {
        title_info = { fg = palette.green; };
        title_warn = { fg = palette.yellow; };
        title_error = { fg = palette.red; };
      };
      pick = {
        border = { fg = palette.green; };
        active = { fg = palette.bg0; bg = palette.green; bold = true; };
        inactive = { fg = palette.fg; };
      };
      input = {
        border = { fg = palette.green; };
        title = { fg = palette.green; };
        value = { fg = palette.fg; };
        selected = { fg = palette.fg; bg = palette.bg_visual; };
      };
      cmp = {
        border = { fg = palette.green; };
        active = { fg = palette.bg0; bg = palette.green; bold = true; };
        inactive = { fg = palette.fg; };
      };
      tasks = {
        border = { fg = palette.green; };
        title = { fg = palette.green; };
        hovered = { fg = palette.bg0; bg = palette.green; bold = true; };
      };
      help = {
        border = { fg = palette.green; };
        chord = { fg = palette.aqua; };
        action = { fg = palette.fg; };
        hovered = { fg = palette.bg0; bg = palette.green; bold = true; };
      };
      filetype = {
        rules = [
          { url = "*"; is = "orphan"; fg = palette.red; }
          { url = "*/"; is = "orphan"; fg = palette.red; }
          { mime = "**/image/*"; fg = palette.yellow; }
          { mime = "**/{audio,video}/*"; fg = palette.purple; }
          { mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"; fg = palette.orange; }
          { mime = "**/application/{pdf,doc,rtf}"; fg = palette.aqua; }
          { mime = "vfs/{absent,stale}"; fg = palette.grey1; }
          { url = "*/"; fg = palette.blue; }
          { url = "*"; is = "exec"; fg = palette.green; }
          { url = "*"; fg = palette.fg; }
        ];
      };
    };
  };
}
