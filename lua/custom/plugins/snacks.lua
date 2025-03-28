---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
        Snacks.toggle.inlay_hints():map '<leader>th'
        Snacks.toggle.diagnostics():map '<leader>tD'
        Snacks.toggle
          .new({
            id = 'format_on_save',
            name = 'Format on Save',
            get = function()
              return not vim.g.disable_autoformat
            end,
            set = function(state)
              vim.g.disable_autoformat = not state
            end,
          })
          :map '<leader>tf'
        Snacks.toggle
          .new({
            id = 'copilot',
            name = 'Copilot',
            get = function()
              return vim.g.copilot_enabled
            end,
            set = function()
              vim.g.copilot_enabled = not vim.g.copilot_enabled
            end,
          })
          :map '<leader>tc'
        Snacks.toggle
          .new({
            id = 'db_ui',
            name = 'DB UI',
            get = function()
              return vim.g.db_ui_open
            end,
            set = function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == '' then
                  vim.api.nvim_buf_delete(buf, { force = true })
                end
              end
              vim.cmd 'DBUIToggle'
            end,
          })
          :map '<leader>td'
      end,
    })
  end,
  opts = {
    explorer = {
      enabled = true,
    },
    image = {
      enabled = true,
    },
    dashboard = {
      preset = {
        header = [[
                                                                                                                                            
                                .. .;>?>]I                                                                                                            
                      .. ..':;. <:xbd\({+^`^.  ..   .  .                                                                                              
                  '`nx'+f_[Yc[CXnX\v\vULj>'+nuvux1{||_'`'                                                                                             
                  .'!MJ,cLqopCdp#kJjbp/qu|UJtLOZUuQJitC?.'' !?'.                                                                                      
                  ..|*U{dp{OpLJwzL<<Ibv,uC_uZ/zUOjQo#*qOLOL+C>_".                                                                                     
                  .':h}l,`"_hhqi . `^.'`}mC_-n[m!ZCmoL[ckboZU\/".']-                                                                                  
                  ':t';~+']!:!)|''   ' .l]XfjxXfkJ]_|tJtUoohmLCLmwt'"'                                                                                
                '^;"'.`l|-(+l<(<+(>'..'' '.'.I;"!i<{10l\/JkduzX{kc--['                                                                                
                ,J'`;cYOhxZ;;X#dfxj]/>)!';.'  '`!"`'"^/1{U(kamwhoZv?^.                                                                                
               '!I'[a<i'\i  'IznwhhOU1fvc+`?     .    ''^[|(?1th`':ii<;.                                                                              
             '.lI ."`.''.    ]pOO/+foM^[fi^~I+!          '1';!+[(x\.                                                                                  
             'j, .;cwm:'   '?OppqO]t/^Uf!:"dc|+fi"!"'^.        l|{_<:.                                                                                
            :1l';|j[1 .~_",;zc< .^(mUh":"!,YtQ<1`.             ,.;i!1(+'                                                                              
          '"I' .[tI'' ;\?_\_[.   ''`(dqxf)nJY\".         '."^;"1|I,'  :t>'                                                                            
          _QJ_,ii_{.;{U[]l'         .'(Zvxc|{_",~'' ";_!^`..   .,>l.   ."+j\                                                                          
          :mxCwuY(uj~"''             `.{wbd-n{l^'. .ri`.        .."?}`:.  .`?j{C01'                                                                   
          '[moqmOu`'                  .iLkakt.    '. .     'I1-1{[//;.      ''''^`!\t?wdn,                                                            
          '''`IuL".                     rh#vi'    ^I<"'''  .'::':,^`'.             '..''`:{)fnmZlI`'.                                                 
               .                 .'';:`''|aOc"`.i:-/z`.      .'' ''.                      '.`.''[1cj?;l~_-+i'  '                                      
                              . `>|_(j"}\ftnrx{Lqz(?^'   ..'.!?{;..                        '!l...'I)(jkwXYJvxC}(>.                                    
                              .,cv`~maod/}'`I})LYz{~,'  ';10qQ};.                          .l[l'  .l~)0cQvt;J//Cjt\_..                                
                              'OOZXXb#hkkQ((cUtj;?'. . `thOav-`                             .<1"'' . ^)-n]-Jt+zn/0dwhmf''.                            
                            ''!vki|jO*qcpaoZbdoh`''`'[:tpJJ,]_.                              ")|^'..  I\>uqC|\Uu"chbfoMWQl''                          
                            .'ip~^~!   ''[Zpdapkbkn?\*hM*Yj;)?;'                          'I>.}O!,^    '\Xz)zvtvlQXQqaqjh#fxf.   '.                   
                              'L{~j'        .^|xzfz0k*kZpbmt|]!!`.''                      {+{,jq"/}'   .`"jJOb{]j-?uhooJCq*Cpt[(i)-1|~                
                            .'(v.+b/^             ."{/QkqQxLCX\x;/l",.'"^`;i'.  '..   `:<?v))'{OUf{^.    .~{p##Ctvz/(cwmdzJqmh*aZr|~^,''              
                            .,L<:~czQ>'               `'!]jaZpO?Zu1uru/]f)/-<:i+/~,iI?<1LUnc~]0md~->'      UkQd*jJcz{LJjUcq|qoqh0+\v\<.'              
                             'XkfxC+)aY~t]n_               .`I!|p*pUO0ZLQmXxJrYnt\uYZpow0(}{jjUaoc-+<\.   'dXZo*|U0f!qunxzn1v_LzYdu~]c,I|-'           
                              'n-^''u'O``+bIz.                  ''....'`^</XLJJX\}>^.'<#dh#boOzmkbJ-lrf   `[0#MnocC(hjIwLUr~xQur". '''Yn_'z^          
                              '^axjj"omaLOq1I'                                        .+Qdophda#Znf}`nn^'.`?+p{Y/awmObprjr)oQQ)z+~Xx>^''}_'`          
                              .'^cwO>^ ~x\}>i.                                        ..:zn\UoaaLbUf!ll^^`~"vX{'MzbmhxUzwLQQjjLL{p[>:f\~'''           
                                .':|/     .'..                                          . 1{-fUuOoowYC'"<>i>{/<..0C*dvpaJJYb+YrQ/ufnrf^:l             
                                 .''.                                                     .',~{c}ak**{xJzc;<<>|,',r/mpxdv}zx?Y|)<[)q)|]/`.            
                                                                                            .',Ui<XOO*kr}["j;,/I..1fYfZrr|O|I_L\(wu_/><-?l.           
                                                                                               .'L`Iwk*bUf;v~-^ZX'[{.  ?n,`''(n:`!Zm)>..,x;           
                                                                                                  -|luYmmdL>;'..Xb|,.    '.}I. '_>`IfkX' .).          
                                                                                                   .1(j/JuJOcff-.Xxj\^.          ";''ih{'.            
                                                                                                      lt_:(doadq,!kUO"'               ,x..            
                                                                                                       ';Y\Xco)YLr+Q\{'               ^?'             
                                                                                                         "q}<qJ;I0z:rb'               .'.             
                                                                                                         '.hn)u" iX~lcp'                              
                                                                                                           ,Ul?Q`'?vz^,l                              
                                                                                                           `n_;/X`.]O>,/..                            
                                                                                                            ;u0![J''1v._|'.                           
                                                                                                            .iQ{.?Y>-q{.If,'                          
                                                                                                              zah,fa}un\(C_''                         
                                                                                                                "0CZi);Jt>I`<!`                       
                                                                                                                 'lvuk\f{pYi{Q-'                      
        ]],
      },
      sections = {
        { section = 'header' },
        { section = 'startup' },
      },
    },
    input = {},
    picker = {
      ui_select = true,
      layouts = {
        select = { layout = { width = 0.5 } },
        default = { layout = { width = 0 } },
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<c-s>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
          },
        },
      },
    },
    lazygit = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>ff',
      function()
        Snacks.picker.smart { filter = { cwd = true } }
      end,
      desc = 'smart find files',
    },
    {
      '<leader>fa',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'buffers',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'grep',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'git status',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'resume',
    },
    {
      '<leader>f.',
      function()
        Snacks.picker.recent { filter = { cwd = true } }
      end,
      desc = 'recent',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'help pages',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'references',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'goto definition',
    },
    {
      'gi',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'goto implementation',
    },
    {
      '<leader>o',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'close others',
    },
    {
      '<leader>O',
      function()
        Snacks.bufdelete.delete()
      end,
      desc = 'close',
    },
    {
      '<leader>fl',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'highlights',
    },
    {
      '<leader>fu',
      function()
        Snacks.picker.undo()
      end,
      desc = 'undo history',
    },
    {
      '<leader>f:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'command history',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>fs',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'lsp symbols',
    },
    {
      '<leader>e',
      function()
        Snacks.explorer { auto_close = true }
      end,
      desc = 'explorer',
    },
    {
      '<leader>fn',
      function()
        Snacks.picker.notifications()
      end,
      desc = 'notifications',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit()
      end,
      desc = 'git: lazy git',
    },
  },
}
