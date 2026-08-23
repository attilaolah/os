final: prev: let
  inherit (builtins) elemAt;

  github-commits = ["NvChad/NvChad" "v2.5" "add44b952d631981614bbb8cfc6f7002f296dfe6"];
  hash-src = "sha256-EuP+/HWJgqwG5LR2rNvtq7mhFkUDs0oyeG6xbbPogC4=";

  githubRepo = prev.lib.splitString "/" (elemAt github-commits 0);
  rev = elemAt github-commits 2;

  nvchad = prev.vimUtils.buildVimPlugin {
    pname = "nvchad";
    version = "${prev.lib.removePrefix "v" (elemAt github-commits 1)}-unstable+rev=${builtins.substring 0 7 rev}";
    # NvChad requires its user-supplied `chadrc` during module loading, so the
    # generic isolated Neovim require check cannot exercise this plugin.
    doCheck = false;
    src = prev.fetchFromGitHub {
      inherit rev;
      owner = elemAt githubRepo 0;
      repo = elemAt githubRepo 1;
      hash = hash-src;
    };
    dependencies = with prev.vimPlugins; [
      gitsigns-nvim
      luasnip
      mason-nvim
      nvim-cmp
      nvim-lspconfig
      telescope-nvim
      nvim-treesitter
      nvchad-ui
    ];
    postPatch = ''
      patch -p1 <<'PATCH'
      --- a/lua/nvchad/plugins/init.lua
      +++ b/lua/nvchad/plugins/init.lua
      @@ -143,10 +143,16 @@
         {
           "nvim-treesitter/nvim-treesitter",
           event = { "BufReadPost", "BufNewFile" },
           cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
      -    build = ":TSUpdate | TSInstallAll",
      -    opts = function()
      -      return require "nvchad.configs.treesitter"
      +    config = function()
      +      local function start_treesitter(event)
      +        pcall(vim.treesitter.start, event.buf)
      +      end
      +
      +      start_treesitter { buf = vim.api.nvim_get_current_buf() }
      +      vim.api.nvim_create_autocmd("FileType", {
      +        callback = start_treesitter,
      +      })
           end,
         },
       }
      PATCH
    '';
  };
in {
  vimPlugins =
    prev.vimPlugins
    // {
      nvchad = nvchad;
    };
}
