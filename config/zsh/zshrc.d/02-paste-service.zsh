# --------------------------------------------------------------------------- #
#*                            Paste Service
# --------------------------------------------------------------------------- #

# OpenSUSE Paste Service (https://paste.opensuse.org)
function pasteit() {
  local file_path=$1
  local private=1
  local author_name="Bad3r"
  local syntax_highlighting="text"
  local response=""
  local paste_id=""
  
  # Supported languages regex
  local supported_langs="^(text|html5|css|javascript|php|python|ruby|lua|bash|erlang|go|c|cpp|diff|latex|sql|xml|0|4cs|6502acme|6502kickass|6502tasm|68000devpac|abap|actionscript|actionscript3|ada|aimms|algol68|apache|applescript|apt_sources|arm|asm|asymptote|asp|autoconf|autohotkey|autoit|avisynth|awk|bascomavr|basic4gl|bbcode|bf|bibtex|blitzbasic|bnf|boo|c_loadrunner|c_mac|c_winapi|caddcl|cadlisp|cfdg|cfm|chaiscript|chapel|cil|clojure|cmake|cobol|coffeescript|cpp-winapi|csharp|cuesheet|d|dart|dcs|dcl|dcpu16|delphi|div|dos|dot|e|ecmascript|eiffel|email|epc|euphoria|ezt|f1|falcon|fo|fortran|freebasic|freeswitch|fsharp|gambas|gdb|genero|genie|gettext|glsl|gml|gnuplot|groovy|gwbasic|haskell|haxe|hicest|hq9plus|html4strict|icon|idl|ini|inno|intercal|io|ispfpanel|j|java|java5|jcl|jquery|klonec|klonecpp|kotlin|lb|ldif|lisp|llvm|locobasic|logcat|logtalk|lolcode|lotusformulas|lotusscript|lscript|lsl2|m68k|magiksf|make|mapbasic|matlab|mirc|mmix|modula2|modula3|mpasm|mxml|mysql|nagios|netrexx|newlisp|nginx|nimrod|nsis|oberon2|objc|objeck|ocaml|octave|oobas|oorexx|oracle11|oracle8|oxygene|oz|parasail|parigp|pascal|pcre|per|perl|perl6|pf|pic16|pike|pixelbender|pli|plsql|postgresql|postscript|povray|powerbuilder|powershell|proftpd|progress|prolog|properties|providex|purebasic|pys60|q|qbasic|qml|racket|rails|rbs|rebol|reg|rexx|robots|rpmspec|rsplus|rust|sas|scala|scheme|scilab|scl|sdlbasic|smalltalk|smarty|spark|sparql|standardml|stonescript|systemverilog|tcl|teraterm|thinbasic|tsql|typoscript|unicon|uscript|upc|urbi|vala|vb|vbnet|vbscript|vedit|verilog|vhdl|vim|visualfoxpro|visualprolog|whitespace|whois|winbatch|xbasic|xorg_conf|xpp|yaml|z80|zxbasic)$"

  if [[ $# -gt 1 ]]; then
    while [[ $# -gt 0 ]]; do
      case $1 in
        -p|--public)
          private=0
          shift ;;
        -a|--author)
          author_name=$2
          shift 2 ;;
        -l|--lang)
          if [[ $2 =~ $supported_langs ]]; then
                syntax_highlighting=$2
          else
            echo "Error: Unsupported language. Use -l with one of the supported language codes."
            return 1
          fi
          shift 2 ;;
        *)
          echo "Unknown option: $1"
          return 1 ;;
      esac
    done
  fi

  local api_url="https://paste.opensuse.org/api/create"

  response=$(curl -s -d "private=${private}" -d "name=${author_name}" --data-urlencode -d "${syntax_highlighting}=@${file_path}" ${api_url})

  paste_id=$(echo ${"response"} | sed -n 's/.*https:\/\/paste.centos.org\/view\/\(.*\)/\1/p')

  if [[ -n $paste_id ]]; then
    echo "File uploaded successfully. Paste URL: https://paste.centos.org/view/${paste_id}"
  else
    echo "Failed to upload file. Error: ${response}"
  fi
}