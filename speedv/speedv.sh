#!/bin/bash

# Default values
input_file=""
output_file=""
speed_factor="1.0"

# Function to display script usage
function usage() {
  echo "Usage: $0 -i/--input <input_file> [-o/--output <output_file>] [--speedfactor=<speed_factor>]"
  echo "Options:"
  echo "  -i, --input   : Input video file"
  echo "  -o, --output  : Output video file (optional)"
  echo "  --speedfactor : Speed factor (default: 1.0)"
  exit 1
}

# Function to get file extension
function get_extension() {
  echo "${1##*.}"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -i|--input)
      input_file="$2"
      shift
      ;;
    -o|--output)
      output_file="$2"
      shift
      ;;
    --speedfactor=*)
      speed_factor="${1#*=}"
      ;;
    *)
      # Unknown option
      echo "Error: Unknown option '$key'"
      usage
      ;;
  esac
  shift
done

# Check if required arguments are provided
if [[ -z "$input_file" ]]; then
  echo "Error: Input file must be specified."
  usage
fi

# If output_file is not provided, generate the output file name with the input file's extension
if [[ -z "$output_file" ]]; then
  extension=$(get_extension "$input_file")
  output_file="output.$extension"
fi

# Perform speedup using ffmpeg
ffmpeg_cmd="ffmpeg -i $input_file -filter_complex \"[0:v]setpts=$(bc <<< "scale=2;1/$speed_factor")*PTS[v];[0:a]atempo=$speed_factor[a]\" -map \"[v]\" -map \"[a]\" $output_file"
echo "Running command: $ffmpeg_cmd"
$ffmpeg_cmd

# ffmpeg -i input_video.mp4 -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" output_video.mp4
