{ constants, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = constants.gitName;
      user.email = constants.gitEmail;
    };
  };
}
