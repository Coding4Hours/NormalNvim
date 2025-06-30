return {
  {
    'nvimdev/galaxyline.nvim',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {'nvim-tree/nvim-web-devicons'}, -- Added dependency
    config = function()
      local cmd = vim.cmd
      local fn = vim.fn
      local gl = require("galaxyline")
      local section = gl.section
      gl.short_line_list = {"LuaTree", "packager", "Floaterm"}

      -- Catppuccin Mocha palette
      local catppuccin_mocha_colors = {
        rosewater = "#F5E0DC",
        flamingo = "#F2CDCD",
        pink = "#F5C2E7",
        mauve = "#CBA6F7",
        red = "#F38BA8",
        maroon = "#EBA0AC",
        peach = "#FAB387",
        yellow = "#F9E2AF",
        green = "#A6E3BD",
        teal = "#94E2D5",
        sky = "#89DCEB",
        sapphire = "#74C7EC",
        blue = "#89B4FA",
        lavender = "#B4BEFE",
        text = "#CDD6F4",
        subtext1 = "#BAC2DE",
        subtext0 = "#A6ADC8",
        overlay2 = "#9399B2",
        overlay1 = "#7F849C",
        overlay0 = "#6C7086",
        surface2 = "#585B70",
        surface1 = "#45475A",
        surface0 = "#313244",
        base = "#1E1E2E",
        mantle = "#181825",
        crust = "#11111B",

        -- Mapping to existing nord_colors keys for easy replacement
        bg = "#1E1E2E",          -- base
        fg = "#CDD6F4",          -- text
        line_bg = "#181825",     -- mantle (slightly darker for line background)
        fg_green = "#A6E3BD",    -- green
        yellow = "#F9E2AF",      -- yellow
        cyan = "#94E2D5",        -- teal (closest)
        darkblue = "#74C7EC",    -- sapphire (closest)
        green = "#A6E3BD",       -- green
        orange = "#FAB387",      -- peach
        purple = "#CBA6F7",      -- mauve
        magenta = "#F38BA8",     -- red (closest to original magenta use case)
        gray = "#585B70",        -- surface2
        blue = "#89B4FA",        -- blue
        red = "#F38BA8"          -- red
      }

      local buffer_not_empty = function()
        if fn.empty(fn.expand("%:t")) ~= 1 then
          return true
        end
        return false
      end

      -- Left section remains the same
      section.left[1] = {
        FirstElement = {
          provider = function()
            return "  "
          end,
          highlight = {catppuccin_mocha_colors.blue, catppuccin_mocha_colors.line_bg}
        }
      }
      section.left[2] = {
        ViMode = {
          provider = function()
            local mode_color = {
              n = catppuccin_mocha_colors.red,
              i = catppuccin_mocha_colors.green,
              v = catppuccin_mocha_colors.blue,
              [" "] = catppuccin_mocha_colors.blue,
              V = catppuccin_mocha_colors.blue,
              c = catppuccin_mocha_colors.red,
              no = catppuccin_mocha_colors.red,
              s = catppuccin_mocha_colors.peach,
              S = catppuccin_mocha_colors.peach,
              [" "] = catppuccin_mocha_colors.peach,
              ic = catppuccin_mocha_colors.yellow,
              R = catppuccin_mocha_colors.purple,
              Rv = catppuccin_mocha_colors.purple,
              cv = catppuccin_mocha_colors.red,
              ce = catppuccin_mocha_colors.red,
              r = catppuccin_mocha_colors.teal,
              rm = catppuccin_mocha_colors.teal,
              ["r?"] = catppuccin_mocha_colors.teal,
              ["!"] = catppuccin_mocha_colors.red,
              t = catppuccin_mocha_colors.red
            }
            cmd("hi GalaxyViMode guifg=" .. mode_color[fn.mode()])
            return "   "
          end,
          highlight = {catppuccin_mocha_colors.red, catppuccin_mocha_colors.line_bg, "bold"}
        }
      }
      section.left[3] = {
        FileIcon = {
          provider = "FileIcon",
          condition = buffer_not_empty,
          highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, catppuccin_mocha_colors.line_bg}
        }
      }
      section.left[4] = {
        FileName = {
          provider = "FileName",
          condition = buffer_not_empty,
          separator = " ",
          separator_highlight = {catppuccin_mocha_colors.purple, catppuccin_mocha_colors.bg},
          highlight = {catppuccin_mocha_colors.purple, catppuccin_mocha_colors.line_bg, "bold"}
        }
      }

      -- 4. LSP Diagnostics
      section.left[5] = {
        DiagnosticError = {
          provider = "DiagnosticError",
          icon = " ",
          highlight = {catppuccin_mocha_colors.red, catppuccin_mocha_colors.line_bg}
        }
      }

      section.left[6] = {
        DiagnosticWarn = {
          provider = "DiagnosticWarn",
          icon = " ",
          highlight = {catppuccin_mocha_colors.yellow, catppuccin_mocha_colors.line_bg}
        }
      }

      -- 3. LSP Client Name (NEW)
      section.mid[1] = {
        LspClient = {
          provider = "GetLspClient",
          icon = "  ",
          highlight = {catppuccin_mocha_colors.sky, catppuccin_mocha_colors.line_bg}
        }
      }

      -- Right section is updated with LSP client and re-ordered for clarity
      local checkwidth = function()
        local squeeze_width = fn.winwidth(0) / 2
        if squeeze_width > 40 then
          return true
        end
        return false
      end

      -- 1. Git Information
      section.right[1] = {
        GitIcon = {
          provider = function()
            return " "
          end,
          condition = require("galaxyline.provider_vcs").check_git_workspace,
          highlight = {catppuccin_mocha_colors.peach, catppuccin_mocha_colors.line_bg}
        }
      }
      section.right[2] = {
        GitBranch = {
          provider = "GitBranch",
          condition = require("galaxyline.provider_vcs").check_git_workspace,
          separator = "",
          separator_highlight = {catppuccin_mocha_colors.purple, catppuccin_mocha_colors.bg},
          highlight = {catppuccin_mocha_colors.peach, catppuccin_mocha_colors.line_bg, "bold"}
        }
      }

      -- 2. Git Diffs
      section.right[3] = {
        DiffAdd = {
          provider = "DiffAdd",
          condition = checkwidth,
          icon = " ",
          highlight = {catppuccin_mocha_colors.green, catppuccin_mocha_colors.line_bg}
        }
      }
      section.right[4] = {
        DiffModified = {
          provider = "DiffModified",
          condition = checkwidth,
          icon = "柳 ",
          highlight = {catppuccin_mocha_colors.yellow, catppuccin_mocha_colors.line_bg}
        }
      }
      section.right[5] = {
        DiffRemove = {
          provider = "DiffRemove",
          condition = checkwidth,
          icon = " ",
          highlight = {catppuccin_mocha_colors.red, catppuccin_mocha_colors.line_bg}
        }
      }


      -- 5. Line and File Information
      section.right[6] = {
        LineInfo = {
          provider = "LineColumn",
          separator = " ",
          separator_highlight = {catppuccin_mocha_colors.blue, catppuccin_mocha_colors.line_bg},
          highlight = {catppuccin_mocha_colors.fg, catppuccin_mocha_colors.line_bg}
        }
      }
      section.right[7] = {
        FileSize = {
          provider = "FileSize",
          condition = buffer_not_empty,
          highlight = {catppuccin_mocha_colors.fg, catppuccin_mocha_colors.line_bg}
        }
      }


      -- Unchanged sections
      section.left[10] = {
        LeftEnd = {
          provider = function()
            return " "
          end,
          separator = " ",
          separator_highlight = {catppuccin_mocha_colors.bg, catppuccin_mocha_colors.line_bg},
          highlight = {catppuccin_mocha_colors.line_bg, catppuccin_mocha_colors.line_bg}
        }
      }

      section.short_line_left[15] = {
        BufferType = {
          provider = "FileTypeName",
          separator = " ",
          separator_highlight = {catppuccin_mocha_colors.purple, catppuccin_mocha_colors.bg},
          highlight = {catppuccin_mocha_colors.fg, catppuccin_mocha_colors.purple}
        }
      }
      section.short_line_right[16] = {
        BufferIcon = {
          provider = "BufferIcon",
          separator = " ",
          separator_highlight = {catppuccin_mocha_colors.purple, catppuccin_mocha_colors.bg},
          highlight = {catppuccin_mocha_colors.fg, catppuccin_mocha_colors.purple}
        }
      }
    end
  }
}
