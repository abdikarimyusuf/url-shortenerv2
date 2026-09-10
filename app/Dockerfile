# Stage 1: Build Stage
FROM python:3.10-alpine AS build

WORKDIR /app

COPY requirements.txt . 

RUN python -m venv /opt/venv

RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

COPY . .

RUN addgroup -S nonrootgroup && \
    adduser -S nonrootuser -G nonrootgroup

# Stage 2: Runtime Stage

FROM python:3.10-alpine AS runtime

WORKDIR /app

COPY --from=build /opt/venv /opt/venv
COPY --from=build /app /app
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

ENV PATH="/opt/venv/bin:$PATH"

USER nonrootuser

EXPOSE 8080

CMD [ "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]