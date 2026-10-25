-- ~/.config/nvim/lua/plugins/alpha.lua
-- ネオン・シティ // cyberpunk dashboard for alpha-nvim (lazy.nvim spec)
-- Needs a Nerd Font + a truecolor terminal (termguicolors).

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local uv = vim.uv or vim.loop

    ---------------------------------------------------------------------------
    -- Palette
    ---------------------------------------------------------------------------
    local palette = {
      "#ff2a6d", -- hot pink
      "#ff5e9c", -- bubblegum
      "#b967ff", -- violet
      "#7b61ff", -- ultraviolet
      "#05d9e8", -- cyan
      "#01ffc3", -- mint
    }

    local function set_static_hl()
      local hl = vim.api.nvim_set_hl
      hl(0, "AlphaTop",      { fg = "#7b61ff", bold = true })
      hl(0, "AlphaSub",      { fg = "#05d9e8", bold = true })
      hl(0, "AlphaGlitch",   { fg = "#f5f5ff", bold = true })
      hl(0, "AlphaButton",   { fg = "#d1d7ff" })
      hl(0, "AlphaShortcut", { fg = "#ff2a6d", bold = true })
      hl(0, "AlphaQuote",    { fg = "#b967ff", italic = true })
      hl(0, "AlphaFooter",   { fg = "#4a4e75" })
      hl(0, "AlphaBorder",   { fg = "#ff2a6d" })
    end
    set_static_hl()
    -- keep colours if the colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_static_hl })

    ---------------------------------------------------------------------------
    -- Header
    ---------------------------------------------------------------------------
    local logo = {
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }

    local function text(val, hl, extra)
      return vim.tbl_extend("force", {
        type = "text",
        val = val,
        opts = { position = "center", hl = hl },
      }, extra or {})
    end

    local function pad(n)
      return { type = "padding", val = n }
    end

    -- one text element per logo line so each can have its own animated colour
    local logo_elements = {}
    for i, line in ipairs(logo) do
      logo_elements[i] = text(line, "AlphaLogo" .. i)
    end

    local top_bar = text("▀▄▀▄▀▄  ネ オ ン ・ シ テ ィ  ▄▀▄▀▄▀", "AlphaTop")
    local sub_bar = text("[ NEURAL LINK ESTABLISHED  //  JACK IN, CHOOMBA ]", "AlphaSub")
    local rule = text(string.rep("━", 50), "AlphaBorder")

    ---------------------------------------------------------------------------
    -- Color-cycling "neon sign" animation (+ occasional glitch flash)
    ---------------------------------------------------------------------------
    local offset = 0
    local function paint(glitch)
      for i = 1, #logo do
        if glitch then
          vim.api.nvim_set_hl(0, "AlphaLogo" .. i, { fg = "#f5f5ff", bold = true })
        else
          local c = palette[((i + offset - 1) % #palette) + 1]
          vim.api.nvim_set_hl(0, "AlphaLogo" .. i, { fg = c, bold = true })
        end
      end
    end
    paint(false)

    local timer
    local function stop_animation()
      if timer then
        timer:stop()
        if not timer:is_closing() then timer:close() end
        timer = nil
      end
    end

    local function start_animation()
      stop_animation()
      timer = uv.new_timer()
      timer:start(
        0,
        160,
        vim.schedule_wrap(function()
          if vim.bo.filetype ~= "alpha" then return end
          local glitch = math.random(1, 30) == 1
          if not glitch then offset = (offset + 1) % #palette end
          paint(glitch)
          pcall(vim.cmd, "redraw")
        end)
      )
    end

    ---------------------------------------------------------------------------
    -- Buttons
    ---------------------------------------------------------------------------
    local function button(sc, icon, label, cmd)
      local b = dashboard.button(sc, icon .. "  " .. label, "<cmd>" .. cmd .. "<CR>")
      b.opts.hl = "AlphaButton"
      b.opts.hl_shortcut = "AlphaShortcut"
      b.opts.width = 40
      b.opts.cursor = 3
      return b
    end

    local buttons = {
      type = "group",
      val = {
        button("f", "󰈞", "JACK INTO FILE",     "Telescope find_files"),
        button("r", "󰋚", "RECENT RUNS",        "Telescope oldfiles"),
        button("g", "󰺮", "GREP THE MATRIX",    "Telescope live_grep"),
        button("n", "󰎔", "NEW BLANK SHARD",    "ene | startinsert"),
        button("c", "󰒓", "RE-FLASH CONFIG",    "e $MYVIMRC"),
        button("l", "󰒲", "PLUGIN BLACKMARKET", "Lazy"),
        button("q", "󰗼", "FLATLINE",           "qa"),
      },
      opts = { spacing = 1 },
    }

    ---------------------------------------------------------------------------
    -- Footer: quote + stats
    ---------------------------------------------------------------------------
    local quotes = {
      "「 The future is already here — it's just not evenly distributed. 」",
      "「 Delete the bugs. Keep the soul. 」",
      "「 Hack the planet, one buffer at a time. 」",
      "「 Chrome fades, :wq is forever. 」",
      "「 In a world of mice, be a keyboard. 」",
      "「 Rain on neon, tea on desk, code on screen. 」",
      "「 There is no spoon. There is only :help. 」",
    }
    math.randomseed(os.time())

    local quote = text(quotes[math.random(#quotes)], "AlphaQuote")
    local footer = text(os.date("  %a %d %b %Y   󰥔 %H:%M"), "AlphaFooter")

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      once = true,
      callback = function()
        local ok, stats = pcall(function() return require("lazy").stats() end)
        if ok then
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          footer.val = string.format(
            "󱐋 %d/%d modules loaded in %sms   %s",
            stats.loaded, stats.count, ms, os.date("󰥔 %H:%M")
          )
          pcall(vim.cmd, "AlphaRedraw")
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- Layout
    ---------------------------------------------------------------------------
    local layout = { pad(2), top_bar, pad(1) }
    vim.list_extend(layout, logo_elements)
    vim.list_extend(layout, { pad(1), sub_bar, rule, pad(1), buttons, pad(1), rule, quote, pad(1), footer })

    alpha.setup({
      layout = layout,
      opts = { margin = 5, noautocmd = true },
    })

    ---------------------------------------------------------------------------
    -- Lifecycle: start/stop animation, tidy up the UI while on the dashboard
    ---------------------------------------------------------------------------
    local group = vim.api.nvim_create_augroup("AlphaCyberpunk", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "AlphaReady",
      callback = function()
        vim.opt_local.cursorline = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        start_animation()
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "AlphaClosed",
      callback = stop_animation,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = stop_animation })
  end,
}
