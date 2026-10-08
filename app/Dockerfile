# Stage 1: Build Stage
FROM python:3.10-alpine AS build

WORKDIR /app

COPY requirements.txt . 

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY . .


# Stage 2: Runtime Stage

FROM python:3.10-alpine AS runtime

WORKDIR /app

RUN addgroup -S nonrootgroup && \
    adduser -S nonrootuser -G nonrootgroup
COPY --from=build /install /usr/local
COPY --from=build /app /app
COPY --from=build /app/entrypoint.sh /app/entrypoint.sh
RUN chmod +x ./entrypoint.sh

USER nonrootuser

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
CMD [ "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]



# /usr/local/lib/python3.10/site-packages = It's where Python normally puts packages installed with pip