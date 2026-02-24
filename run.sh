  GNU nano 8.7.1                                                                                                                                                                                                                                                                                                    run.sh                                                                                                                                                                                                                                                                                                              
#!/bin/bash
set -e

echo "========== AI RUN SCRIPT =========="

PROJECT_DIR="/root/AI/comfy"
cd $PROJECT_DIR || exit

echo "Installing python venv dependencies..."
apt update
apt install -y python3.13-venv python3.13-full python3-pip python3.11 python3.11-venv python3.11-full || true

# remove broken venv
rm -rf venv || true

echo "Trying Python 3.13 venv..."
if python3 -m ensurepip --upgrade && python3 -m venv venv; then
    echo "Python 3.13 venv created"
else
    echo "Python 3.13 failed, using Python 3.11..."
    python3.11 -m venv venv
fi

echo "Activating venv..."
source venv/bin/activate

pip install --upgrade pip

if [ -f "requirements.txt" ]; then
    echo "Installing requirements..."
    pip install -r requirements.txt
fi

echo "Starting AI..."
python main.py

echo "================================="
echo "        ComfyUI Launcher"
echo "================================="

PORT=8188
ATM_DIR="$(pwd)"

# ===============================
# Auto Install System Dependencies
# ===============================

install_package() {
    if command -v apt >/dev/null 2>&1; then
        apt update
        apt install -y "$@"
    elif command -v apk >/dev/null 2>&1; then
        apk add "$@"
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y "$@"
    else
        echo "No supported package manager found."
        exit 1
    fi
}

# Install python3 if missing
if ! command -v python3 >/dev/null 2>&1; then
    echo "Installing python3..."
    install_package python3
fi

# Install pip if missing
if ! command -v pip3 >/dev/null 2>&1; then
    echo "Installing pip..."
    install_package python3-pip
fi

# Install venv if missing
if ! python3 -m venv --help >/dev/null 2>&1; then
    echo "Installing python3-venv..."
    install_package python3-venv
fi

# Install git & curl if missing
for cmd in git curl; do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo "Installing $cmd..."
        install_package $cmd
    fi
done

# ===============================
# Install / Repair ComfyUI
# ===============================

COMFY_BASE="$HOME/AI"
COMFY_DIR="$COMFY_BASE/comfy"

mkdir -p "$COMFY_BASE"

# If folder exists but not a git repo  ^f^r delete it
if [ -d "$COMFY_DIR" ] && [ ! -d "$COMFY_DIR/.git" ]; then
    echo "Corrupted ComfyUI folder detected. Removing..."
    rm -rf "$COMFY_DIR"
fi

# If git repo missing  ^f^r clone fresh
if [ ! -d "$COMFY_DIR/.git" ]; then
    echo "Installing ComfyUI..."
    cd "$COMFY_BASE" || exit 1
    git clone https://github.com/comfyanonymous/ComfyUI.git comfy || exit 1
else
    echo "ComfyUI already installed."
fi

cd "$COMFY_DIR" || exit 1

echo "Installing Python dependencies globally..."
pip3 install --upgrade pip
pip3 install -r requirements.txt

# Start ComfyUI
cd "$COMFY_DIR" || exit 1

# Install Python dependencies if missing
if ! python3 -c "import sqlalchemy" >/dev/null 2>&1; then
    echo "Installing Python dependencies..."
    python3 -m pip install --break-system-packages --upgrade pip
    python3 -m pip install --break-system-packages -r requirements.txt
fi

# ===============================
# STARTING_COMFY_UI
# ===============================


echo "Starting ComfyUI..."

python3 main.py \
  --listen \
  --port "$PORT" \
  --input-directory "$ATM_DIR" &

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






