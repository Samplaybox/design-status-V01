#!/bin/bash
set -e

echo "Creating Python virtual environment..."

if [ ! -d /workspace/.venv ]; then
    python -m venv /workspace/.venv
else
    echo "Virtual environment already exists."
fi

source /workspace/.venv/bin/activate

echo "Upgrading pip and installing backend dependencies..."

pip install --upgrade pip

if [ -f /workspace/design-status-V01/backend/requirements.txt ]; then
    pip install -r /workspace/design-status-V01/backend/requirements.txt
elif [ -f /workspace/backend/requirements.txt ]; then
    pip install -r /workspace/backend/requirements.txt
else
    echo "No backend/requirements.txt found; creating minimal one."
    mkdir -p /workspace/design-status-V01/backend
    cat <<'EOF' > /workspace/design-status-V01/backend/requirements.txt
fastapi
uvicorn
python-multipart
openpyxl
pydantic
pytest
httpx
psycopg2-binary
sqlalchemy
python-dotenv
EOF
    pip install -r /workspace/design-status-V01/backend/requirements.txt
fi

echo "Installing Linux packages required by Codex sandboxing..."

if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y bubblewrap
else
    echo "apt-get not found. Skipping bubblewrap installation."
fi

echo "Setting venv auto-activation..."

for shell_rc in ~/.bashrc ~/.zshrc; do
    touch "$shell_rc"
    if ! grep -q "source /workspace/.venv/bin/activate" "$shell_rc"; then
        echo 'source /workspace/.venv/bin/activate' >> "$shell_rc"
    fi
done

echo "Installing Codex CLI..."

if command -v npm >/dev/null 2>&1; then
    npm list -g @openai/codex >/dev/null 2>&1 || npm install -g @openai/codex@latest
else
    echo "npm not found. Codex CLI was not installed."
fi

echo "Post-create setup completed."
