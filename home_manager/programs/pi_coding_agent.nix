{pkgs, ...}: let
  qwen = "qwen3.8-flash-next";
in {
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.pi-coding-agent;
    models.providers.openai = {
      api = "openai-responses";
      # Local Headroom proxy:
      baseUrl = "http://localhost:8787/v1";
      models = [
        {id = qwen;}
      ];
    };
    settings = {
      theme = "dark";
      packages = [
        "${pkgs.pi-mcp-adapter}/lib/node_modules/pi-mcp-adapter"
      ];
      defaultModel = qwen;
      defaulProvider = "openai";
      enabledModels = [
        qwen
        "gpt-5.6-*"
        "gpt-6-*"
      ];
    };
  };
}
