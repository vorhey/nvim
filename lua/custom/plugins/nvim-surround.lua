return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  config = function()
    vim.g.nvim_surround_no_normal_mappings = true
    vim.g.nvim_surround_no_visual_mappings = true
    vim.g.nvim_surround_no_insert_mappings = true

    require('nvim-surround').setup {}

    vim.keymap.set('n', 'gs', '<Plug>(nvim-surround-normal)', { desc = 'Add surrounding (normal)' })
    vim.keymap.set('n', 'gss', '<Plug>(nvim-surround-normal-cur)', { desc = 'Add surrounding (line)' })
    vim.keymap.set('x', 'S', '<Plug>(nvim-surround-visual)', { desc = 'Add surrounding (visual)' })
    vim.keymap.set('x', 'gS', '<Plug>(nvim-surround-visual-line)', { desc = 'Add surrounding (visual line)' })
    vim.keymap.set('n', 'ds', '<Plug>(nvim-surround-delete)', { desc = 'Delete surrounding' })
    vim.keymap.set('n', 'cs', '<Plug>(nvim-surround-change)', { desc = 'Change surrounding' })
    vim.keymap.set('n', 'cS', '<Plug>(nvim-surround-change-line)', { desc = 'Change surrounding (line)' })
  end,
}

-- ============================================================================
-- USAGE EXAMPLES WITH YOUR KEYBINDINGS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ADDING SURROUNDINGS (gs in normal mode)
-- ----------------------------------------------------------------------------
-- gs{motion}{char} - Add surrounding characters around a motion
--
-- Examples:
--   gsiw"       : Surround inner word with quotes
--                 hello -> "hello"
--
--   gsiw'       : Surround inner word with single quotes
--                 hello -> 'hello'
--
--   gsiw(       : Surround inner word with parentheses (with spaces)
--                 hello -> ( hello )
--
--   gsiw)       : Surround inner word with parentheses (no spaces)
--                 hello -> (hello)
--
--   gs$"        : Surround from cursor to end of line with quotes
--                 hello world -> "hello world"
--
--   gsap{       : Surround around paragraph with curly braces
--                 text -> { text }
--
--   gsi]{       : Surround inside square brackets with curly braces
--                 [hello] -> [{hello}]
--
--   gs2w"       : Surround next 2 words with quotes
--                 hello world test -> "hello world" test
--
--   gsit<div>   : Surround inner tag content with div tags
--                 content -> <div>content</div>

-- ----------------------------------------------------------------------------
-- ADDING SURROUNDINGS (S in visual mode)
-- ----------------------------------------------------------------------------
-- Select text first, then press S{char}
--
-- Examples:
--   viw S"      : Select inner word, then surround with quotes
--                 hello -> "hello"
--
--   V S{        : Select entire line, surround with braces
--                 hello world -> { hello world }
--
--   vap S(      : Select around paragraph, surround with parentheses
--                 text -> ( text )
--
--   v3w S'      : Select 3 words, surround with single quotes
--                 one two three -> 'one two three'
--
--   viW S`      : Select inner WORD, surround with backticks
--                 hello-world -> `hello-world`
--
--   <C-v> S*    : Block select, then surround each line with asterisks
--                 line1      *line1*
--                 line2  ->  *line2*
--                 line3      *line3*

-- ----------------------------------------------------------------------------
-- DELETING SURROUNDINGS (ds)
-- ----------------------------------------------------------------------------
-- ds{char} - Delete the surrounding characters
--
-- Examples:
--   ds"         : Delete surrounding quotes
--                 "hello" -> hello
--
--   ds'         : Delete surrounding single quotes
--                 'hello' -> hello
--
--   ds(         : Delete surrounding parentheses
--                 (hello) -> hello
--
--   ds)         : Also deletes surrounding parentheses
--                 (hello) -> hello
--
--   ds{         : Delete surrounding curly braces
--                 {hello} -> hello
--
--   ds[         : Delete surrounding square brackets
--                 [hello] -> hello
--
--   dst         : Delete surrounding HTML tags
--                 <div>hello</div> -> hello
--
--   ds`         : Delete surrounding backticks
--                 `hello` -> hello

-- ----------------------------------------------------------------------------
-- CHANGING SURROUNDINGS (cs)
-- ----------------------------------------------------------------------------
-- cs{old}{new} - Change surrounding from old to new
--
-- Examples:
--   cs"'        : Change double quotes to single quotes
--                 "hello" -> 'hello'
--
--   cs'`        : Change single quotes to backticks
--                 'hello' -> `hello`
--
--   cs({        : Change parentheses to curly braces
--                 (hello) -> {hello}
--
--   cs){        : Change parentheses to curly braces with spaces
--                 (hello) -> { hello }
--
--   cs[<div>    : Change square brackets to div tags
--                 [hello] -> <div>hello</div>
--
--   cst<span>   : Change HTML tags to span tags
--                 <div>hello</div> -> <span>hello</span>
--
--   cs"`        : Change double quotes to backticks
--                 "hello" -> `hello`
--
--   cs><        : Change > to < (for custom surroundings)
--                 >hello< -> <hello>

-- ----------------------------------------------------------------------------
-- SPECIAL CHARACTERS AND TARGETS
-- ----------------------------------------------------------------------------
-- b or ) - Parentheses: )
-- B or } - Curly braces: }
-- r or ] - Square brackets: ]
-- a or > - Angle brackets: >
-- t     - HTML tags
-- w     - Word
-- W     - WORD (includes punctuation)
-- s     - Sentence
-- p     - Paragraph
-- "     - Double quotes
-- '     - Single quotes
-- `     - Backticks

-- ----------------------------------------------------------------------------
-- ADVANCED EXAMPLES
-- ----------------------------------------------------------------------------
-- Function calls:
--   gsiw)       : print -> print()
--   csw"f       : "text" -> f("text")  (if you have function surrounding set up)
--
-- HTML/JSX:
--   gsi]tdiv    : [content] -> <div>[content]</div>
--   cst"        : <span>text</span> -> "text"
--
-- Markdown:
--   gsiw*       : word -> *word* (italic)
--   gsiw**      : word -> **word** (bold)
--   cs*`        : *code* -> `code`
--
-- Multiple operations:
--   ds" . gsiw( : "hello" -> hello -> (hello)
--   cs"' . S{   : "hello" -> 'hello' -> {'hello'} (after visual selection)

-- ----------------------------------------------------------------------------
-- TIPS
-- ----------------------------------------------------------------------------
-- 1. Use ( or { for surrounding with spaces, ) or } without spaces
-- 2. The 't' target works with any HTML/XML tags
-- 3. You can use counts: 2ds" deletes two levels of quotes
-- 4. Works with vim motions: gs3w" surrounds next 3 words
-- 5. Dot repeat (.) works with these operations
-- 6. Visual mode (S) is great for irregular selections
-- 7. Line-wise visual mode (V) surrounds entire lines
