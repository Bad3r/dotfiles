module.exports = {
  config: {
// https://www.npmjs.com/package/hyperterm-overlay

    overlay: {
	alwaysOnTop: true,
        animate: true,
	hasShadow: false,
	hideDock: false,
	hideOnBlur: false,
        hotkeys: ['CmdOrCtrl+Space'],
	position: 'top',
        primaryDisplay: false,
        resizable: true,
	startAlone: false,
       startup: false,
        size: 0.4,
	tray: true,
	unique: false
    },

// https://www.npmjs.com/package/hyperline
hyperline: {
      color: '#000',
      plugins: [
        {
          name: 'hostname',
          options: {
            color: 'lightWhite'
          }
        },
        {
          name: 'memory',
          options: {
            color: 'lightWhite'
          }
        },
        {
          name: 'uptime',
          options: {
            color: 'lightWhite'
          }
        },
        {
          name: 'cpu',
          options: {
            colors: {
              high: 'red',
              moderate: 'lightWhite',
              low: 'lightWhite'
            }
          }
        },
        {
          name: 'network',
          options: {
            color: 'lightWhite'
          }
        },
        {
          name: 'battery',
          options: {
            colors: {
              fine: 'lightWhite',
              critical: 'red'
            }
          }
        }
      ]
    },
// default font size in pixels for all tabs
  fontSize: 12,

    // font family with optional fallbacks
    fontFamily: 'Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
//fontFamily: 'Tamsyn',
    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: 'rgba(248,28,229,0.8)',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BLOCK',

    // color of the text
    foregroundColor: '#eff0eb',

    // terminal background color
    backgroundColor: '#000',

    // border color (window, tabs)
    borderColor: 'rgba(255, 106, 193, 0.25)',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: '',

    // set to `true` if you're using a Linux set up
    // that doesn't shows native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: '',

    // set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px 14px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#000000',
      red: '#ff5c57',
      green: '#5af78e',
      yellow: '#f3f99d',
      blue: '#57c7ff',
      magenta: '#ff6ac1',
      cyan: '#9aedfe',
      white: '#d0d0d0',
      lightBlack: '#808080',
      lightRed: '#ff5c57',
      lightGreen: '#5af78e',
     lightYellow: '#f3f99d',
      lightBlue: '#57c7ff',
      lightMagenta: '#ff6ac1',
      lightCyan: '#9aedfe',
      lightWhite: '#eff0eb'
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: '',

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ['--login'],

    // for environment variables
    env: {},

    // set to false for no bell
    bell: 'SOUND',

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg

  
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
  'hyperterm-title',
'hyperterm-alternatescroll',
'hyperline',
'hyperterm-overlay',
'hyper-tab-icons',
'hyperlinks',
'hyperterm-themed-scrollbar',  
  ],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []
};
