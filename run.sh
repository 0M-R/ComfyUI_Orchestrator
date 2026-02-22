#!/bin/bash

echo "================================="
echo "        ComfyUI Launcher"
echo "================================="

COMFY_DIR="$HOME/AI/comfy"
ATM_DIR="/home/om/atm"
PORT=8188
HOST="127.0.0.1"

# Check directories
if [ ! -d "$COMFY_DIR" ]; then
    echo "Error: ComfyUI directory not found."
    exit 1
fi

if [ ! -d "$ATM_DIR" ]; then
    echo "Error: ATM project directory not found."
    exit 1
fi

# Start ComfyUI
cd "$COMFY_DIR" || exit 1

echo "Starting ComfyUI..."

python3 main.py \
  --listen \
  --port "$PORT" \
  --input-directory "$ATM_DIR" &

COMFY_PID=$!

echo "Waiting for ComfyUI to become available..."

until curl -s "http://$HOST:$PORT" > /dev/null; do
    sleep 2
done

echo "ComfyUI is running on http://$HOST:$PORT"
echo ""

# Workflow selection
cd "$ATM_DIR" || exit 1

echo "Select workflow to execute:"
echo "1) MULTI_PRINT"
echo "2) MULTI_ANGLE"
echo ""

read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "Running main.py..."
        python3 main.py
        ;;
    2)
        echo "Running multiangle.py..."
        python3 multiangle.py
        ;;
    *)
        echo "Invalid selection."
        ;;
esac

# Keep ComfyUI running until manually stopped
wait "$COMFY_PID"

echo "ComfyUI stopped."
