{ ... }:
{
  programs.codex = {
    enable = true;
    mutableSettings = true;
    context = ../../codex-agents.md;
    settings = {
      approvals_reviewer = "auto_review";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
    };
  };
}
