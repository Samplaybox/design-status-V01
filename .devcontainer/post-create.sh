#!/bin/bash
set -e

echo "Creating Python virtual environment..."
python -m venv /workspace/.venv
source /workspace/.venv/bin/activate

echo "Upgrading pip and installing dependencies..."
if [ -f /workspace/backend/requirements.txt ]; then
    pip install --upgrade pip
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
    pip install --upgrade pip
    pip install -r /workspace/backend/requirements.txt
fi

echo "Post-create setup completed."

