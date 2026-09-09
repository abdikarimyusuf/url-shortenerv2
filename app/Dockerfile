# Stage 1: Build Stage
FROM python:3.10-slim AS build

WORKDIR /app

COPY requirements.txt . 

RUN python -m venv /opt/venv

RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime Stage

FROM python:3.10-slim AS runtime

WORKDIR /app

COPY --from=build /opt/venv /opt/venv
COPY . .

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 8080

CMD [ "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]