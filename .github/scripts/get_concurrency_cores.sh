#!/bin/bash
# Script to detect CPU cores and return optimal concurrency count
# Used for optimizing parallel execution in GitHub Actions and local development

# Function to get CPU cores using multiple methods
get_cpu_cores() {
  # Try multiple methods in order of portability
  local cores=$(
    # Primary: getconf (works on Linux and macOS)
    getconf _NPROCESSORS_ONLN 2>/dev/null ||
    # Fallback: nproc for Linux
    nproc 2>/dev/null ||
    # Fallback: sysctl for macOS/BSD
    sysctl -n hw.ncpu 2>/dev/null ||
    # Fallback: Windows environment variable
    echo "$NUMBER_OF_PROCESSORS" 2>/dev/null ||
    # Final fallback
    echo "2"
  )
  
  # Ensure we have a valid number
  if ! [[ "$cores" =~ ^[0-9]+$ ]]; then
    cores=2
  fi
  
  echo "$cores"
}

# Main logic
main() {
  local total_cores=$(get_cpu_cores)
  local half_cores=$(( (total_cores + 1) / 2 ))
  
  # Ensure at least 1 core
  if [ "$half_cores" -lt 1 ]; then
    half_cores=1
  fi
  
  # Output based on arguments
  case "${1:-}" in
    --total)
      echo "$total_cores"
      ;;
    --debug)
      echo "Total cores: $total_cores" >&2
      echo "Half cores: $half_cores" >&2
      echo "$half_cores"
      ;;
    *)
      echo "$half_cores"
      ;;
  esac
}

# Run main function
main "$@"