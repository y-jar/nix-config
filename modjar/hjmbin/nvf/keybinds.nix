[
  # ===[General]
  {
    mode = "n";
    key = "<leader>w";
    action = ":w<CR>";
    desc = "Save file";
    silent = false;
  }
  {
    mode = "n";
    key = "<leader>q";
    action = ":q<CR>";
    desc = "Quit window";
    silent = false;
  }
  {
    mode = "n";
    key = "<Esc>";
    action = "<cmd>nohlsearch<CR>";
    desc = "Clear search highlight";
  }

  # ===[Find/Telescope]
  {
    mode = "n";
    key = "<leader>ff";
    action = "<cmd>Telescope find_files<CR>";
    desc = "Find files";
  }
  {
    mode = "n";
    key = "<leader>fg";
    action = "<cmd>Telescope live_grep<CR>";
    desc = "Live grep";
  }
  {
    mode = "n";
    key = "<leader>fb";
    action = "<cmd>Telescope buffers<CR>";
    desc = "Find buffers";
  }
  {
    mode = "n";
    key = "<leader>fh";
    action = "<cmd>Telescope help_tags<CR>";
    desc = "Find help";
  }

  # ===[Buffer navigation]
  {
    mode = "n";
    key = "<S-h>";
    action = "<cmd>bprevious<CR>";
    desc = "Previous buffer";
  }
  {
    mode = "n";
    key = "<S-l>";
    action = "<cmd>bnext<CR>";
    desc = "Next buffer";
  }
  {
    mode = "n";
    key = "<leader>bd";
    action = "<cmd>bdelete<CR>";
    desc = "Delete buffer";
  }

  # ===[Window navigation]
  {
    mode = "n";
    key = "<C-h>";
    action = "<C-w>h";
    desc = "Move to left split";
  }
  {
    mode = "n";
    key = "<C-j>";
    action = "<C-w>j";
    desc = "Move to lower split";
  }
  {
    mode = "n";
    key = "<C-k>";
    action = "<C-w>k";
    desc = "Move to upper split";
  }
  {
    mode = "n";
    key = "<C-l>";
    action = "<C-w>l";
    desc = "Move to right split";
  }
  {
    mode = "n";
    key = "<leader>wv";
    action = "<C-w>v";
    desc = "Vertical split";
  }
  {
    mode = "n";
    key = "<leader>ws";
    action = "<C-w>s";
    desc = "Horizontal split";
  }
  {
    mode = "n";
    key = "<leader>wd";
    action = "<C-w>c";
    desc = "Close split";
  }

  # ===[Git]
  {
    mode = "n";
    key = "<leader>gp";
    action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
    desc = "Preview git hunk";
  }

  # ===[Filetree]
  {
    mode = "n";
    key = "<leader>ee";
    action = "<cmd>NvimTreeToggle<CR>";
    desc = "Toggle file explorer";
  }
  {
    mode = "n";
    key = "<leader>ef";
    action = "<cmd>NvimTreeFindFile<CR>";
    desc = "Find current file in tree";
  }

  # ===[Diagnostics]
  {
    mode = "n";
    key = "<leader>xx";
    action = "<cmd>Telescope diagnostics<CR>";
    desc = "Workspace diagnostics";
  }
  {
    mode = "n";
    key = "<leader>xd";
    action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    desc = "Line diagnostic";
  }
  {
    mode = "n";
    key = "[d";
    action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    desc = "Previous diagnostic";
  }
  {
    mode = "n";
    key = "]d";
    action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    desc = "Next diagnostic";
  }

  # ===[LSP]
  {
    mode = "n";
    key = "gd";
    action = "<cmd>lua vim.lsp.buf.definition()<CR>";
    desc = "Go to definition";
  }
  {
    mode = "n";
    key = "gr";
    action = "<cmd>lua vim.lsp.buf.references()<CR>";
    desc = "References";
  }
  {
    mode = "n";
    key = "K";
    action = "<cmd>lua vim.lsp.buf.hover()<CR>";
    desc = "Hover documentation";
  }
  {
    mode = "n";
    key = "<leader>ca";
    action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    desc = "Code action";
  }
  {
    mode = "n";
    key = "<leader>rn";
    action = "<cmd>lua vim.lsp.buf.rename()<CR>";
    desc = "Rename symbol";
  }
  {
    mode = "n";
    key = "<leader>lf";
    action = "<cmd>lua vim.lsp.buf.format()<CR>";
    desc = "Format file";
  }
]
