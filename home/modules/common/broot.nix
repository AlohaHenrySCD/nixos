{ theme, ... }:
let
  inherit (theme) palette;
in
{
  programs.broot = {
    enable = true;
    settings = {
      imports = [ "verbs.hjson" ];
      icon_theme = "nerdfont";
      true_colors = true;

      # Everforest Dark Medium, matching Kitty and Yazi.
      skin = {
        default = "${palette.fg} ${palette.bg0} / ${palette.grey2} ${palette.bg0}";
        tree = "${palette.bg5} none";
        parent = "${palette.grey2} none";
        file = "${palette.fg} none";
        directory = "${palette.blue} none bold / ${palette.blue} none";
        exe = "${palette.green} none";
        link = "${palette.aqua} none";
        pruning = "${palette.grey1} none italic";
        perm__ = "${palette.bg5} none";
        perm_r = "${palette.yellow} none";
        perm_w = "${palette.red} none";
        perm_x = "${palette.green} none";
        owner = "${palette.purple} none";
        group = "${palette.grey2} none";
        count = "${palette.purple} ${palette.bg1}";
        dates = "${palette.grey1} none";
        sparse = "${palette.orange} none";
        content_extract = "${palette.grey2} none";
        content_match = "${palette.yellow} none bold";
        device_id_major = "${palette.purple} none";
        device_id_sep = "${palette.grey1} none";
        device_id_minor = "${palette.purple} none";
        git_branch = "${palette.purple} none";
        git_insertions = "${palette.green} none";
        git_deletions = "${palette.red} none";
        git_status_current = "${palette.bg5} none";
        git_status_modified = "${palette.yellow} none";
        git_status_staged = "${palette.green} none";
        git_status_new = "${palette.aqua} none bold";
        git_status_ignored = "${palette.grey1} none";
        git_status_conflicted = "${palette.red} none bold";
        git_status_other = "${palette.orange} none";
        selected_line = "none ${palette.bg3} / none ${palette.bg2}";
        char_match = "${palette.yellow} none bold";
        file_error = "${palette.red} none";
        flag_label = "${palette.grey2} ${palette.bg1}";
        flag_value = "${palette.green} ${palette.bg1} bold";
        input = "${palette.fg} ${palette.bg1} / ${palette.grey1} ${palette.bg1}";
        status_error = "${palette.red} ${palette.bg_red}";
        status_job = "${palette.yellow} ${palette.bg2}";
        status_normal = "${palette.fg} ${palette.bg1} / ${palette.grey1} ${palette.bg1}";
        status_italic = "${palette.green} ${palette.bg1} italic";
        status_bold = "${palette.green} ${palette.bg1} bold";
        status_code = "${palette.aqua} ${palette.bg2}";
        status_ellipsis = "${palette.grey1} ${palette.bg1}";
        purpose_normal = "${palette.fg} ${palette.bg1}";
        purpose_italic = "${palette.green} ${palette.bg1} italic";
        purpose_bold = "${palette.green} ${palette.bg1} bold";
        purpose_ellipsis = "${palette.grey1} ${palette.bg1}";
        scrollbar_track = "${palette.bg2} none";
        scrollbar_thumb = "${palette.grey1} none / ${palette.bg5} none";
        help_paragraph = "${palette.fg} none";
        help_bold = "${palette.green} none bold";
        help_italic = "${palette.purple} none italic";
        help_code = "${palette.aqua} ${palette.bg2}";
        help_headers = "${palette.green} none bold";
        help_table_border = "${palette.bg5} none";
        preview = "${palette.fg} ${palette.bg0} / ${palette.grey2} ${palette.bg0}";
        preview_title = "${palette.green} ${palette.bg1} / ${palette.grey2} ${palette.bg1}";
        preview_line_number = "${palette.grey1} ${palette.bg1}";
        preview_separator = "${palette.bg5} none";
        preview_match = "none ${palette.bg_yellow}";
        diff_line_number = "${palette.grey1} ${palette.bg1}";
        diff_added = "${palette.green} ${palette.bg_green}";
        diff_removed = "${palette.red} ${palette.bg_red}";
        hex_null = "${palette.bg5} none";
        hex_ascii_graphic = "${palette.fg} none";
        hex_ascii_whitespace = "${palette.yellow} none";
        hex_ascii_other = "${palette.orange} none";
        hex_non_ascii = "${palette.purple} none";
        staging_area_title = "${palette.green} ${palette.bg1} / ${palette.grey1} ${palette.bg1}";
        mode_command_mark = "${palette.bg0} ${palette.green} bold";
        good_to_bad_0 = palette.green;
        good_to_bad_1 = palette.green;
        good_to_bad_2 = palette.aqua;
        good_to_bad_3 = palette.aqua;
        good_to_bad_4 = palette.yellow;
        good_to_bad_5 = palette.yellow;
        good_to_bad_6 = palette.orange;
        good_to_bad_7 = palette.orange;
        good_to_bad_8 = palette.red;
        good_to_bad_9 = palette.red;
      };
    };
  };
}
