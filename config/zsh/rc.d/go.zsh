# Tool: Go
# Desc: The Go programming language compiler and tools

if ! (( $+commands[go] )); then
    return
fi

# Go workspace and binary locations
export GOPATH="${GOPATH:=$HOME/go}"
export GOBIN="${GOBIN:=$GOPATH/bin}"
[ -d "$GOBIN" ] && PATH="$PATH:$GOBIN"

# ===============================================================================
# GOEXPERIMENT Configuration
# ===============================================================================
# View available experiments: go doc runtime/internal/sys.GOEXPERIMENT
# View current experiments: go env GOEXPERIMENT
# View all experiments: go version -m <binary> | grep -E '^\s+build\s+GOEXPERIMENT'

# Enable selected Go experiments for enhanced performance and features
export GOEXPERIMENT="greenteagc,jsonv2,boringcrypto,newinliner,fieldtrack,cgocheck2,synctest,dwarf5"

# ===============================================================================
# Go Experiment Documentation
# ===============================================================================

# GreenTeaGC 🍵
# -------------
# New garbage collector with redesigned allocator
# Go Doc: go doc runtime/internal/sys.GOEXPERIMENT | grep -A2 GreenTeaGC
#
# Advantages:
#   - 10-40% reduction in GC overhead  
#   - Lower pause times and better throughput
#   - Reduced memory fragmentation
#
# Disadvantages:
#   - May use slightly more memory initially
#   - Different performance characteristics might affect existing tuning
#   - Still experimental, may have undiscovered edge cases

# JSONv2 📦
# ---------
# Complete JSON package rewrite with improved performance
# Go Doc: go doc encoding/json/v2 (when available)
#
# Advantages:
#   - Better performance (faster marshal/unmarshal operations)
#   - Native streaming support for large JSON documents
#   - More detailed error messages with location information
#   - More configuration options for customization
#
# Disadvantages:
#   - Different API from json v1 (requires code changes)
#   - May break existing JSON handling assumptions
#   - Some third-party libraries may not be compatible

# BoringCrypto 🔐
# ---------------
# Uses BoringSSL for FIPS 140-2 compliance
# Go Doc: go doc crypto/internal/boring
#
# Advantages:
#   - FIPS 140-2 certification for government/enterprise requirements
#   - Validated cryptographic implementation
#   - Consistent crypto behavior across platforms
#
# Disadvantages:
#   - Larger binary size (includes BoringSSL)
#   - Limited to specific crypto algorithms (no custom crypto)
#   - Slower than Go's native crypto implementation
#   - CGO dependency required

# NewInliner ⚡
# ------------
# Improved function inlining heuristics for better optimization
# Go Doc: go doc cmd/compile/internal/inline
#
# Advantages:
#   - Better performance (5-10% improvement in many cases)
#   - Smarter inlining decisions based on cost/benefit analysis
#   - Reduced function call overhead
#
# Disadvantages:
#   - Larger binary size from more aggressive inlining
#   - Different optimization patterns may affect existing benchmarks
#   - May increase compile time

# FieldTrack 📊
# -------------
# Tracks struct field usage for dead code elimination
# Go Doc: go doc cmd/compile | grep -A2 fieldtrack
#
# Advantages:
#   - Dead code elimination for unused struct fields
#   - Smaller binary sizes
#   - Better cache locality from reduced struct sizes
#
# Disadvantages:
#   - Build time overhead for analysis
#   - May break reflection-heavy code that accesses fields dynamically
#   - Incompatible with some code generation tools

# CgoCheck2 🔍
# ------------
# Stricter cgo pointer checking for memory safety
# Go Doc: go doc runtime.SetCgoCheck
#
# Advantages:
#   - Catches more cgo safety violations at runtime
#   - Prevents memory corruption from incorrect pointer passing
#   - Better debugging of cgo-related crashes
#
# Disadvantages:
#   - Runtime overhead for all cgo calls
#   - May reject previously working (but unsafe) code
#   - Performance impact on cgo-heavy applications

# Synctest 🧪
# -----------
# Deterministic concurrent testing framework
# Go Doc: go doc internal/synctest (Go 1.24+)
#
# Advantages:
#   - Reproducible concurrent test execution
#   - Easier debugging of race conditions
#   - Deterministic test failures for CI/CD
#
# Disadvantages:
#   - Tests run slower due to synchronization
#   - Not representative of production timing behavior
#   - May hide real-world race conditions

# Dwarf5 🐛
# ---------
# Modern DWARF v5 debug format
# Go Doc: go doc debug/dwarf
#
# Advantages:
#   - Better debugging experience with more metadata
#   - Smaller debug info sections (10-20% reduction)
#   - Improved support for optimized code debugging
#
# Disadvantages:
#   - Older debuggers (GDB < 10, LLDB < 14) incompatible
#   - Some profiling tools may not support DWARF v5
#   - Platform-specific debugger issues possible

# ===============================================================================
# Additional Go Environment Variables
# ===============================================================================

# Build and compilation settings
export GOPROXY="${GOPROXY:=https://proxy.golang.org,direct}"
export GOSUMDB="${GOSUMDB:=sum.golang.org}"
export GOPRIVATE="${GOPRIVATE:=}"  # Set to private repos, e.g., "github.com/mycompany/*"

# Performance tuning
export GOGC="${GOGC:=100}"          # GC target percentage (lower = more frequent GC)
export GOMEMLIMIT="${GOMEMLIMIT:=}" # Memory limit for the Go runtime (e.g., "1GiB")
export GOMAXPROCS="${GOMAXPROCS:=}" # Max CPU cores (defaults to runtime.NumCPU())

# Development settings
export GO111MODULE="${GO111MODULE:=on}"
export CGO_ENABLED="${CGO_ENABLED:=1}"  # Required for BoringCrypto

# ===============================================================================
# Go Aliases and Functions
# ===============================================================================

# Build with all experiments
alias gobuild-exp='go build -ldflags="-s -w"'
alias gorun-exp='go run'

# Show current experiments
alias goexp='go env GOEXPERIMENT'

# Show experiment documentation
goexp-doc() {
    if [[ -z "$1" ]]; then
        echo "Available experiments in current config:"
        echo "$GOEXPERIMENT" | tr ',' '\n' | sed 's/^/  - /'
        echo ""
        echo "Usage: goexp-doc <experiment>"
        echo "Example: goexp-doc greenteagc"
    else
        go doc runtime/internal/sys.GOEXPERIMENT | grep -A5 -i "$1"
    fi
}

# Test with different experiment combinations
gotest-exp() {
    local original_exp="$GOEXPERIMENT"
    
    echo "Testing with experiments: $1"
    export GOEXPERIMENT="$1"
    go test ./...
    
    export GOEXPERIMENT="$original_exp"
}

# ===============================================================================
# Quick Reference Commands
# ===============================================================================

# Help function for Go experiments
gohelp() {
    cat << 'EOF'
Go Experiment Quick Reference:

View Commands:
  goexp                - Show current GOEXPERIMENT setting
  goexp-doc            - Show documentation for experiments
  go env GOEXPERIMENT  - Show active experiments
  go doc runtime/internal/sys.GOEXPERIMENT - Full experiment list

Build Commands:
  gobuild-exp    - Build with all configured experiments

Test Commands:
  gotest-exp <experiments> - Test with specific experiments

Current Configuration:
EOF
    echo "  GOEXPERIMENT=$GOEXPERIMENT"
    echo "  GOPATH=$GOPATH"
    echo "  GOBIN=$GOBIN"
}
