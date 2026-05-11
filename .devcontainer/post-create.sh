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

# Auto-activate venv in every new Bash terminal
if ! grep -q "source /workspace/.venv/bin/activate" ~/.bashrc; then
    echo 'source /workspace/.venv/bin/activate' >> ~/.bashrc
fi

echo "Post-create setup completed."

