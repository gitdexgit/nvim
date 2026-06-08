return
{
  'echasnovski/mini.operators',
  version = false,
  config = function()
    require('mini.operators').setup({
      -- Exchange (swap) operator
      exchange = {
        prefix = 'gs',
      },
      -- Disable others if you don't want them (optional)
      evaluate = { prefix = '' },
      multiply = { prefix = '' },
      replace  = { prefix = '' },
      sort     = { prefix = '' },
    })
  end,
}
