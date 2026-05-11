#!/bin/bash
set -e

echo "Creating Python virtual environment..."

if [ ! -d /workspace/.venv ]; then
    python -m venv /workspace/.venv
else
    echo "Virtual environment already exists."
fi

source /workspace/.venv/bin/activate

echo "Upgrading pip and installing dependencies..."

pip install --upgrade pip

if [ -f /workspace/backend/requirements.txt ]; then
    pip install -r /workspace/backend/requirements.txt
else
    echo "No backend/requirements.txt found; creating minimal one."
    mkdir -p /workspace/backend
    cat <<'EOF' > /workspace/backend/requirements.txt
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
    pip install -r /workspace/backend/requirements.txt
fi

echo "Setting venv auto-activation..."

if ! grep -q "source /workspace/.venv/bin/activate" ~/.bashrc; then
    echo 'source /workspace/.venv/bin/activate' >> ~/.bashrc
fi

echo "Installing Codex CLI..."

if command -v npm >/dev/null 2>&1; then
    npm list -g @openai/codex >/dev/null 2>&1 || npm install -g @openai/codex
else
    echo "npm not found. Codex CLI was not installed."
fi

echo "Post-create setup completed."